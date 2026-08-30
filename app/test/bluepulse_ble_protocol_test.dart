import 'package:bluepulse_app/src/ble/bluepulse_ble_protocol.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('decodifica pacote BLE v1 little-endian', () {
    final packet = BluePulseBlePacket.parse([
      1,
      0x07,
      42,
      0,
      0,
      0,
      0x10,
      0x27,
      0,
      0,
      80,
      0,
    ]);

    expect(packet.version, 1);
    expect(packet.sequence, 42);
    expect(packet.infrared, 10000);
    expect(packet.movementIndex, 0.08);
    expect(packet.mpuValid, isTrue);
    expect(packet.contactDetected, isTrue);
    expect(packet.movementDetected, isTrue);
    expect(packet.sensorFailure, isFalse);
  });

  test('rejeita tamanho e versão incompatíveis', () {
    expect(() => BluePulseBlePacket.parse([1, 0]), throwsFormatException);
    expect(
      () => BluePulseBlePacket.parse(List<int>.filled(12, 2)),
      throwsFormatException,
    );
  });
}
