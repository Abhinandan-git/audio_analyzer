import 'dart:math' as math;
import 'dart:collection';

/// Provides beat computation using the Beat Detection Algorithm.
/// 
/// This class implements BDA to convert the magnitudes of frequency-domain signals
/// into a boolean value whether the beat is detected or not.
class BeatEngine {
  final double lowFrequencyMin;
  final double lowFrequencyMax;
  final double highFrequencyMin;
  final double highFrequencyMax;
  final double historySize;
  final Queue<double> energyHistory = Queue<double>();

  BeatEngine({
    this.lowFrequencyMin = 60.0,
    this.lowFrequencyMax = 250.0,
    this.highFrequencyMin = 250.0,
    this.highFrequencyMax = 2000.0,
    this.historySize = 43
  });

  /// Computes the beat using the magnitude vector.
  /// 
  /// Parameters:
  ///   - `magnitudes`: A list of double values representin the frequency-domain magnitudes.
  /// 
  /// Returns:
  ///   A boolean value representing whether the current instance is a beat or not.
  bool detectBeat(List<double> magnitudes) {
    final double lowBandEnergy = _calculateEnergy(magnitudes, lowFrequencyMin, lowFrequencyMax);
    final double highBandEnergy = _calculateEnergy(magnitudes, highFrequencyMin, highFrequencyMax);
    
    final double totalBandEnergy = lowBandEnergy * 1.5 + highBandEnergy;

    energyHistory.addLast(totalBandEnergy);
    if (energyHistory.length < historySize) {
      return false;
    }

    final double energyThreshold = energyHistory.reduce((a, b) => a + b) / energyHistory.length;
    final double variance = energyHistory.map((e) => math.pow(e - energyThreshold, 2)).reduce((a, b) => a + b) / energyHistory.length;

    return energyThreshold - variance < totalBandEnergy && energyThreshold + variance > totalBandEnergy;
  }

  /// Calculate energy in a freuqncy range from magnitude data.
  double _calculateEnergy(List<double> magnitudes, double initialFrequency, double endFrequency) {
    final int minBin = (initialFrequency * 1024 / 44100).round();
    final int maxBin = (endFrequency * 1024 / 44100).round();

    double energy = 0.0;
    for (int i = minBin; i <= maxBin && i < magnitudes.length; i++) {
      energy += magnitudes[i] * magnitudes[i];
    }

    return energy;
  }

  /// Clearing the history of current song for the next.
  void reset() {
    energyHistory.clear();
  }
}
