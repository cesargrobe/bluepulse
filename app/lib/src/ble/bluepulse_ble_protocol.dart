import 'dart:typed_data';

const bluePulseDeviceName = 'BluePulse-ESP32';
const bluePulseServiceUuid = '7d2a0001-8f5b-4c2d-a9e1-3b6f5c7d9000';
const bluePulseSampleUuid = '7d2a0002-8f5b-4c2d-a9e1-3b6f5c7d9000';
const _uint32Modulus = 0x100000000;
const _uint32HalfRange = 0x80000000;

class BluePulseBleTransmissionStats {
  const BluePulseBleTransmissionStats({
    required this.received,
    required this.missing,
    required this.duplicates,
    required this.outOfOrder,
    required this.firstSequence,
    required this.lastSequence,
  });

  final int received;
  final int missing;
  final int duplicates;
  final int outOfOrder;
  final int? firstSequence;
  final int? lastSequence;

  int get sequentialReceived => received - duplicates - outOfOrder;

  double get deliveryPercentage {
    final expected = sequentialReceived + missing;
    return expected == 0 ? 0 : sequentialReceived * 100 / expected;
  }
}

class BluePulseBleSequenceTracker {
  int _received = 0;
  int _missing = 0;
  int _duplicates = 0;
  int _outOfOrder = 0;
  int? _firstSequence;
  int? _lastSequence;

  void add(int sequence) {
    if (sequence < 0 || sequence >= _uint32Modulus) {
      throw RangeError.range(sequence, 0, _uint32Modulus - 1, 'sequence');
    }

    _received++;
    final last = _lastSequence;
    if (last == null) {
      _firstSequence = sequence;
      _lastSequence = sequence;
      return;
    }

    final forwardDistance = (sequence - last) % _uint32Modulus;
    if (forwardDistance == 0) {
      _duplicates++;
    } else if (forwardDistance < _uint32HalfRange) {
      _missing += forwardDistance - 1;
      _lastSequence = sequence;
    } else {
      _outOfOrder++;
    }
  }

  BluePulseBleTransmissionStats get snapshot => BluePulseBleTransmissionStats(
    received: _received,
    missing: _missing,
    duplicates: _duplicates,
    outOfOrder: _outOfOrder,
    firstSequence: _firstSequence,
    lastSequence: _lastSequence,
  );

  void reset() {
    _received = 0;
    _missing = 0;
    _duplicates = 0;
    _outOfOrder = 0;
    _firstSequence = null;
    _lastSequence = null;
  }
}

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
