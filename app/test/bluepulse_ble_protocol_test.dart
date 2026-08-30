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

  test('contabiliza sequência contínua sem perdas', () {
    final tracker = BluePulseBleSequenceTracker();
    tracker
      ..add(100)
      ..add(101)
      ..add(102);

    final stats = tracker.snapshot;
    expect(stats.received, 3);
    expect(stats.missing, 0);
    expect(stats.duplicates, 0);
    expect(stats.outOfOrder, 0);
    expect(stats.deliveryPercentage, 100);
  });

  test('contabiliza lacunas, duplicações e pacotes fora de ordem', () {
    final tracker = BluePulseBleSequenceTracker();
    tracker
      ..add(10)
      ..add(12)
      ..add(12)
      ..add(11);

    final stats = tracker.snapshot;
    expect(stats.received, 4);
    expect(stats.missing, 1);
    expect(stats.duplicates, 1);
    expect(stats.outOfOrder, 1);
    expect(stats.deliveryPercentage, closeTo(66.67, 0.01));
  });

  test('aceita a passagem circular da sequência uint32', () {
    final tracker = BluePulseBleSequenceTracker();
    tracker
      ..add(0xfffffffe)
      ..add(0xffffffff)
      ..add(0);

    final stats = tracker.snapshot;
    expect(stats.missing, 0);
    expect(stats.outOfOrder, 0);
    expect(stats.deliveryPercentage, 100);
  });
}
