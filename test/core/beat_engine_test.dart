import 'package:flutter_test/flutter_test.dart';
import 'package:audio_analyzer/core/beat_engine.dart';

void main() {
  group('BeatEngine Tests', () {
    late BeatEngine beatEngine;

    setUp(() {
      beatEngine = BeatEngine();
    });

    test('detectBeat returns false when history is below threshold', () {
      final magnitudes = List<double>.filled(1024, 0.0);
      final result = beatEngine.detectBeat(magnitudes);
      expect(result, false);
    });

    test('detectBeat returns false for low energy signal', () {
      final magnitudes = List<double>.filled(1024, 0.1);
      for (int i = 0; i < 43; i++) {
        beatEngine.detectBeat(magnitudes);
      }
      final result = beatEngine.detectBeat(magnitudes);
      expect(result, false);
    });

    test('detectBeat returns true for high energy spike', () {
      final lowMagnitudes = List<double>.filled(1024, 0.1);
      for (int i = 0; i < 43; i++) {
        beatEngine.detectBeat(lowMagnitudes);
      }
      final highMagnitudes = List<double>.filled(1024, 2.0);
      final result = beatEngine.detectBeat(highMagnitudes);
      expect(result, true);
    });

    test('reset clears energy history', () {
      final magnitudes = List<double>.filled(1024, 1.0);
      beatEngine.detectBeat(magnitudes);
      beatEngine.reset();
      final result = beatEngine.detectBeat(magnitudes);
      expect(result, false);
    });

    test('constructor initializes with default frequency ranges', () {
      expect(beatEngine.lowFrequencyMin, 60.0);
      expect(beatEngine.highFrequencyMax, 2000.0);
    });
  });
}
