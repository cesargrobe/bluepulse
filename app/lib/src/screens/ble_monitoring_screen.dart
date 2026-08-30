import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../ble/bluepulse_ble_protocol.dart';
import '../models/session_draft.dart';

enum _BleStage { ready, scanning, found, connecting, connected, error }

class BleMonitoringScreen extends StatefulWidget {
  const BleMonitoringScreen({required this.sessionDraft, super.key});

  final SessionDraft sessionDraft;

  @override
  State<BleMonitoringScreen> createState() => _BleMonitoringScreenState();
}

class _BleMonitoringScreenState extends State<BleMonitoringScreen> {
  _BleStage _stage = _BleStage.ready;
  BluetoothDevice? _device;
  BluePulseBlePacket? _packet;
  String? _message;
  int _nearbyDevices = 0;
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;
  StreamSubscription<List<int>>? _sampleSubscription;

  Future<void> _scan() async {
    setState(() {
      _stage = _BleStage.scanning;
      _device = null;
      _message = null;
      _nearbyDevices = 0;
    });

    try {
      if (!await FlutterBluePlus.isSupported) {
        throw Exception('Este aparelho não oferece Bluetooth Low Energy.');
      }

      if (FlutterBluePlus.adapterStateNow != BluetoothAdapterState.on) {
        await FlutterBluePlus.turnOn(timeout: 15);
        await FlutterBluePlus.adapterState
            .where((state) => state == BluetoothAdapterState.on)
            .first
            .timeout(const Duration(seconds: 15));
      }

      await _scanSubscription?.cancel();
      _scanSubscription = FlutterBluePlus.onScanResults.listen((results) {
        if (mounted) setState(() => _nearbyDevices = results.length);
        for (final result in results) {
          final advertisement = result.advertisementData;
          final hasBluePulseService = advertisement.serviceUuids.contains(
            Guid(bluePulseServiceUuid),
          );
          if (advertisement.advName == bluePulseDeviceName ||
              hasBluePulseService) {
            FlutterBluePlus.stopScan();
            if (mounted) {
              setState(() {
                _device = result.device;
                _stage = _BleStage.found;
              });
            }
            return;
          }
        }
      });

      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
      await FlutterBluePlus.isScanning.where((value) => !value).first;

      if (mounted && _device == null) {
        setState(() {
          _stage = _BleStage.error;
          _message = _nearbyDevices == 0
              ? 'Nenhum dispositivo BLE foi detectado. Verifique o Bluetooth do tablet.'
              : 'Foram detectados $_nearbyDevices dispositivos BLE próximos, mas nenhum anunciou o nome ou o serviço BluePulse. Verifique se o OLED mostra BLE: ANUNCIANDO.';
        });
      }
    } catch (error) {
      _showError(_friendlyError(error));
    }
  }

  Future<void> _connect() async {
    final device = _device;
    if (device == null) return;
    setState(() {
      _stage = _BleStage.connecting;
      _message = null;
    });

    try {
      _connectionSubscription = device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected &&
            mounted &&
            _stage == _BleStage.connected) {
          setState(() {
            _stage = _BleStage.error;
            _message = 'A conexão foi interrompida. Nenhum valor foi estimado para substituir as amostras perdidas.';
          });
        }
      });
      await device.connect(
        license: License.nonprofit,
        timeout: const Duration(seconds: 12),
      );
      final services = await device.discoverServices();

      BluetoothCharacteristic? sampleCharacteristic;
      for (final service in services) {
        if (service.uuid == Guid(bluePulseServiceUuid)) {
          for (final characteristic in service.characteristics) {
            if (characteristic.uuid == Guid(bluePulseSampleUuid)) {
              sampleCharacteristic = characteristic;
              break;
            }
          }
        }
      }
      if (sampleCharacteristic == null) {
        throw Exception('Serviço BLE BluePulse v1 incompatível.');
      }

      _sampleSubscription = sampleCharacteristic.onValueReceived.listen(
        _receiveSample,
      );
      await sampleCharacteristic.setNotifyValue(true);
      _receiveSample(await sampleCharacteristic.read());
      if (mounted) setState(() => _stage = _BleStage.connected);
    } catch (error) {
      await device.disconnect();
      _showError(_friendlyError(error));
    }
  }

  void _receiveSample(List<int> bytes) {
    try {
      final packet = BluePulseBlePacket.parse(bytes);
      if (mounted) setState(() => _packet = packet);
    } on FormatException catch (error) {
      _showError(error.message);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    setState(() {
      _stage = _BleStage.error;
      _message = message;
    });
  }

  Future<void> _disconnect() async {
    await _device?.disconnect();
    if (mounted) {
      setState(() {
        _stage = _BleStage.ready;
        _device = null;
        _packet = null;
        _message = null;
      });
    }
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _connectionSubscription?.cancel();
    _sampleSubscription?.cancel();
    if (FlutterBluePlus.isScanningNow) FlutterBluePlus.stopScan();
    _device?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conexão com o protótipo')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Chip(
                    avatar: Icon(Icons.bluetooth_rounded, size: 18),
                    label: Text('DADOS REAIS — PROTÓTIPO'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(_description, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  if (_stage == _BleStage.scanning ||
                      _stage == _BleStage.connecting)
                    const Center(child: CircularProgressIndicator()),
                  if (_stage == _BleStage.connected && _packet != null)
                    _PacketPanel(packet: _packet!),
                  if (_message != null)
                    Card(
                      color: const Color(0xFFFEE2E2),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(_message!),
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Card(
                    color: Color(0xFFFFFBEB),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'IR > 5000 e movimento >= 0.08 são limiares provisórios de bancada. BPM, SpO₂ e GSR permanecem indisponíveis. O sistema não realiza diagnóstico clínico.',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_stage == _BleStage.ready || _stage == _BleStage.error)
                    FilledButton.icon(
                      key: const Key('scan-bluepulse'),
                      onPressed: _scan,
                      icon: const Icon(Icons.search_rounded),
                      label: const Text('Buscar BluePulse-ESP32'),
                    )
                  else if (_stage == _BleStage.found)
                    FilledButton.icon(
                      key: const Key('connect-bluepulse'),
                      onPressed: _connect,
                      icon: const Icon(Icons.bluetooth_connected_rounded),
                      label: const Text('Conectar ao protótipo'),
                    )
                  else if (_stage == _BleStage.connected)
                    OutlinedButton.icon(
                      key: const Key('disconnect-bluepulse'),
                      onPressed: _disconnect,
                      icon: const Icon(Icons.link_off_rounded),
                      label: const Text('Desconectar'),
                    ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Voltar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String get _title => switch (_stage) {
    _BleStage.ready => 'ESP32 pronto para conexão',
    _BleStage.scanning => 'Buscando o BluePulse-ESP32',
    _BleStage.found => 'Protótipo encontrado',
    _BleStage.connecting => 'Conectando e validando o protocolo',
    _BleStage.connected => 'Recebendo amostras reais',
    _BleStage.error => 'Não foi possível concluir',
  };

  String get _description => switch (_stage) {
    _BleStage.ready => 'A busca solicitará a permissão de dispositivos próximos. O aplicativo não usa o Bluetooth para determinar localização.',
    _BleStage.scanning => 'Aguarde por até 10 segundos.',
    _BleStage.found => 'O anúncio e o serviço BluePulse v1 foram localizados.',
    _BleStage.connecting => 'Descobrindo o serviço e ativando notificações.',
    _BleStage.connected =>
      'As leituras abaixo vêm do ESP32 e não são armazenadas nesta versão.',
    _BleStage.error => 'Você pode verificar o ESP32 e tentar novamente.',
  };
}

class _PacketPanel extends StatelessWidget {
  const _PacketPanel({required this.packet});

  final BluePulseBlePacket packet;

  @override
  Widget build(BuildContext context) {
    final status = packet.sensorFailure
        ? 'Falha no MPU65xx'
        : packet.movementDetected
        ? 'Amostra afetada por movimento'
        : packet.contactDetected
        ? 'Contato provisório detectado'
        : 'Sem contato';

    return Card(
      color: packet.sensorFailure
          ? const Color(0xFFFEE2E2)
          : const Color(0xFFDCFCE7),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              status,
              key: const Key('ble-sample-status'),
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Sequência: ${packet.sequence}'),
            Text('IR bruto: ${packet.infrared}'),
            Text(
              'Índice de movimento: ${packet.movementIndex.toStringAsFixed(3)}',
            ),
            Text(
              'MPU65xx: ${packet.mpuValid ? 'leitura válida' : 'indisponível'}',
            ),
            const SizedBox(height: 8),
            const Text('BPM / SpO₂ / GSR: não disponíveis'),
          ],
        ),
      ),
    );
  }
}

String _friendlyError(Object error) {
  final text = error.toString();
  if (text.toLowerCase().contains('permission')) {
    return 'A permissão de dispositivos próximos não foi concedida. Autorize-a para buscar o ESP32.';
  }
  if (text.toLowerCase().contains('bluetooth') &&
      text.toLowerCase().contains('turned on')) {
    return 'O Bluetooth do tablet está desligado. Ative-o no painel rápido e toque novamente em Buscar BluePulse-ESP32.';
  }
  if (text.contains('timeout')) {
    return 'A conexão excedeu o tempo esperado. Verifique o ESP32 e tente novamente.';
  }
  return text.replaceFirst('Exception: ', '');
}
