import 'dart:math';

import 'package:audio_analyzer/core/utils/complex.dart';

/// Provides Fast Fourier Transform (FFT) computation using the Cooley-Tukey algorithm.
/// 
/// This class implements FFT to convert time-domain signals into frequency-domain
/// representation, useful for analyzing audio frequencies and spectral content.
class FFTEngine {
  /// Computes the Fast Fourier Transform of a coefficient vector.
  /// 
  /// Takes a list of real-valued coefficients and returns their frequency magnitudes
  /// using the recursive Cooley-Tukey FFT algorithm.
  /// 
  /// Parameters:
  ///   - `coefficientVector`: A list of double values representing the time-domain signal.
  /// 
  /// Returns:
  ///   A list of doubles representing the magnitude spectrum of the input signal.
  List<double> fft(List<double> coefficientVector) {
    List<Complex> vector = _convert(coefficientVector);

    vector = _fftHelper(vector);

    return vector.map((element) => element.magnitude).toList();
  }

  /// Converts a list of real-valued doubles to complex numbers with zero imaginary parts.
  /// 
  /// Parameters:
  ///   - `vector`: A list of real-valued coefficients.
  /// 
  /// Returns:
  ///   A list of Complex numbers with the input values as real parts.
  List<Complex> _convert(List<double> vector) {
    List<Complex> returnValue = [];
    
    for (double magnitude in vector) {
      returnValue.add(Complex(magnitude));
    }

    return returnValue;
  }

  /// Recursively computes the FFT using the Cooley-Tukey algorithm.
  /// 
  /// Splits the input vector into even and odd indexed elements, recursively
  /// computes their FFT, and combines results using twiddle factors.
  /// 
  /// Parameters:
  ///   - `vector`: A list of Complex numbers to transform.
  /// 
  /// Returns:
  ///   A list of Complex numbers representing the frequency-domain values.
  List<Complex> _fftHelper(List<Complex> vector) {
    final int size = vector.length;

    if (size == 1) {
      return [vector[0]];
    }

    List<Complex> evenVector = _fftHelper(_compute(vector, true));
    List<Complex> oddVector = _fftHelper(_compute(vector, false));

    final double angle = -2 * pi / size;

    List<Complex> returnVector = List.filled(size, Complex(0.0, 0.0));

    for (int idx = 0; idx < size ~/ 2; idx++) {
      final Complex p = evenVector[idx];
      final Complex q = oddVector[idx] * Complex(cos(angle * idx), sin(angle * idx));
      
      returnVector[idx] = p + q;
      returnVector[idx + size ~/ 2] = p - q;
    }

    return returnVector;
  }

  /// Splits the input vector into even or odd indexed elements.
  /// 
  /// Parameters:
  ///   - `vector`: The input vector to split.
  ///   - `isEven`: If true, extracts even indices; if false, extracts odd indices.
  /// 
  /// Returns:
  ///   A list containing alternating elements based on the `isEven` flag.
  List<Complex> _compute(List<Complex> vector, bool isEven) {
    List<Complex> returnValue = [];

    for (int idx = (isEven ? 0 : 1); idx < vector.length; idx += 2) {
      returnValue.add(vector[idx]);
    }

    return returnValue;
  }
}
