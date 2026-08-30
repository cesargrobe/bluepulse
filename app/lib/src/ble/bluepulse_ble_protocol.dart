import 'dart:typed_data';

const bluePulseDeviceName = 'BluePulse-ESP32';
const bluePulseServiceUuid = '7d2a0001-8f5b-4c2d-a9e1-3b6f5c7d9000';
const bluePulseSampleUuid = '7d2a0002-8f5b-4c2d-a9e1-3b6f5c7d9000';

class BluePulseBlePacket {
  const BluePulseBlePacket({
    required this.version,
    required this.sequence,
    required this.infrared,
    required this.movementIndex,
    required this.mpuValid,
    required this.contactDetected,
    required this.movementDetected,
    required this.sensorFailure,
  });

  final int version;
  final int sequence;
  final int infrared;
  final double movementIndex;
  final bool mpuValid;
  final bool contactDetected;
  final bool movementDetected;
  final bool sensorFailure;

  static BluePulseBlePacket parse(List<int> bytes) {
    if (bytes.length != 12) {
      throw const FormatException(
        'O pacote BLE deve conter exatamente 12 bytes.',
      );
    }

    final data = ByteData.sublistView(Uint8List.fromList(bytes));
    final version = data.getUint8(0);
    if (version != 1) {
      throw FormatException('Versão BLE não suportada: $version.');
    }

    final flags = data.getUint8(1);
    return BluePulseBlePacket(
      version: version,
      sequence: data.getUint32(2, Endian.little),
      infrared: data.getInt32(6, Endian.little),
      movementIndex: data.getUint16(10, Endian.little) / 1000,
      mpuValid: flags & 0x01 != 0,
      contactDetected: flags & 0x02 != 0,
      movementDetected: flags & 0x04 != 0,
      sensorFailure: flags & 0x08 != 0,
    );
  }
}
