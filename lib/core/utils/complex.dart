import 'dart:math';

/// A class representing a complex number with real and imaginary parts.
///
/// This class provides basic arithmetic operations and utility methods
/// for working with complex numbers in the form a + bi, where a is the
/// real part and b is the imaginary part.
///
/// Example:
/// ```dart
/// final c1 = Complex(3.0, 4.0);  // 3 + 4i
/// final c2 = Complex(1.0, 2.0);  // 1 + 2i
/// final sum = c1 + c2;            // 4 + 6i
/// final product = c1 * c2;        // -5 + 10i
/// final mag = c1.magnitude;       // 5.0
/// ```
class Complex {
  /// The real part of the complex number.
  ///
  /// Defaults to 0.0 if not specified.
  final double? _real;

  /// The imaginary part of the complex number.
  ///
  /// Defaults to 0.0 if not specified.
  final double? _imaginary;

  /// Creates a new `Complex` number.
  ///
  /// Parameters `real` and `imaginary` default to 0.0 if not provided.
  Complex([this._real = 0.0, this._imaginary = 0.0]);

  /// Adds two complex numbers using the + operator.
  ///
  /// Returns a new `Complex` number representing the sum.
  /// Formula: `(a + bi) + (c + di) = (a + c) + (b + d)i`
  Complex operator +(Complex secondComplex) {
    final double firstRealPart = _real ?? 0.0;
    final double secondRealPart = secondComplex.realPart;
    final double firstImaginaryPart = _imaginary ?? 0.0;
    final double secondImaginaryPart = secondComplex.imaginaryPart;

    return Complex(
      firstRealPart + secondRealPart,
      firstImaginaryPart + secondImaginaryPart
    );
  }

  /// Subtracts two complex numbers using the + operator.
  ///
  /// Returns a new `Complex` number representing the sum.
  /// Formula: `(a + bi) - (c + di) = (a - c) + (b - d)i`
  Complex operator -(Complex secondComplex) {
    final double firstRealPart = _real ?? 0.0;
    final double secondRealPart = secondComplex.realPart;
    final double firstImaginaryPart = _imaginary ?? 0.0;
    final double secondImaginaryPart = secondComplex.imaginaryPart;

    return Complex(
      firstRealPart - secondRealPart,
      firstImaginaryPart - secondImaginaryPart
    );
  }

  /// Multiplies two complex numbers using the * operator.
  ///
  /// Returns a new `Complex` number representing the product.
  /// Formula: `(a + bi) * (c + di) = (ac - bd) + (ad + bc)i`
  Complex operator *(Complex secondComplex) {
    final double firstRealPart = _real ?? 0.0;
    final double secondRealPart = secondComplex.realPart;
    final double firstImaginaryPart = _imaginary ?? 0.0;
    final double secondImaginaryPart = secondComplex.imaginaryPart;

    return Complex(
      (firstRealPart * secondRealPart) - (firstImaginaryPart * secondImaginaryPart),
      (firstRealPart * secondImaginaryPart) + (firstImaginaryPart * secondRealPart)
    );
  }

  /// Gets the real part of this complex number.
  ///
  /// Returns 0.0 if the real part is null.
  double get realPart => _real ?? 0.0;

  /// Gets the imaginary part of this complex number.
  ///
  /// Returns 0.0 if the imaginary part is null.
  double get imaginaryPart => _imaginary ?? 0.0;

  /// Calculates the magnitude (absolute value) of this complex number.
  ///
  /// The magnitude is calculated as `√(a² + b²)` where a is the real part
  /// and b is the imaginary part.
  double get magnitude {
    final double realPart = _real ?? 0.0;
    final double imaginaryPart = _imaginary ?? 0.0;

    return sqrt(realPart * realPart + imaginaryPart * imaginaryPart);
  }
}
