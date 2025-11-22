import 'package:audio_analyzer/core/fft_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FFT Tests', () {
    test('FFT of impulse returns all ones', () {
      final engine = FFTEngine();
      final result = engine.fft([1.0, 0.0, 0.0, 0.0]);

      expect(result.length, 4);
      for (final mag in result) {
        expect(mag, closeTo(1.0, 1e-9));
      }
    });

    test('FFT of 1-bin sinusoid matches expected spectrum', () {
      final engine = FFTEngine();
      final input = [0.0, 1.0, 0.0, -1.0];
      final result = engine.fft(input);

      expect(result[0], closeTo(0.0, 1e-9));
      expect(result[1], closeTo(2.0, 1e-9));
      expect(result[2], closeTo(0.0, 1e-9));
      expect(result[3], closeTo(2.0, 1e-9));
    });

    test('FFT of constant signal has only DC component', () {
      final engine = FFTEngine();
      final input = [1.0, 1.0, 1.0, 1.0];
      final result = engine.fft(input);

      expect(result[0], closeTo(4.0, 1e-9));
      expect(result[1], closeTo(0.0, 1e-9));
      expect(result[2], closeTo(0.0, 1e-9));
      expect(result[3], closeTo(0.0, 1e-9));
    });

    test('FFT of cosine signal matches expected spectrum', () {
      final engine = FFTEngine();
      final input = [1.0, 0.0, -1.0, 0.0];
      final result = engine.fft(input);

      expect(result[0], closeTo(0.0, 1e-9));
      expect(result[1], closeTo(2.0, 1e-9));
      expect(result[2], closeTo(0.0, 1e-9));
      expect(result[3], closeTo(2.0, 1e-9));
    });
  });
}
