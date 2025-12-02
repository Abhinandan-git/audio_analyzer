import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Audio visualizer widget that displays a circular waveform animation
class Visualizer extends StatelessWidget {
  const Visualizer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white10,
      alignment: Alignment.center,
      child: SizedBox(
        height: 200,
        width: 200,
        child: _VisualizerCircleCanvas(),
      ),
    );
  }
}

/// Custom painter widget for the circular visualizer
class _VisualizerCircleCanvas extends StatefulWidget {
  const _VisualizerCircleCanvas();

  @override
  State<_VisualizerCircleCanvas> createState() => _VisualizerCircleState();
}

class _VisualizerCircleState extends State<_VisualizerCircleCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _CircleVisualizerPainter(animationValue: _controller.value),
          child: const Center(
            child: Icon(Icons.music_note, size: 50, color: Colors.white),
          ),
        );
      },
    );
  }
}

/// Custom painter for drawing the circular waveform
class _CircleVisualizerPainter extends CustomPainter {
  final double animationValue;

  _CircleVisualizerPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;
    final paint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Draw circular waveform with animated bars
    const barCount = 32;
    for (int i = 0; i < barCount; i++) {
      final angle = (i / barCount) * 2 * math.pi;

      // Create wave effect with animation
      final waveOffset =
          math.sin(angle * 3 + animationValue * 2 * math.pi) * 10;
      final barRadius = radius + waveOffset + 10;

      final startX = center.dx + math.cos(angle) * radius;
      final startY = center.dy + math.sin(angle) * radius;
      final endX = center.dx + math.cos(angle) * barRadius;
      final endY = center.dy + math.sin(angle) * barRadius;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }

    // Draw center circle
    final centerPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.8, centerPaint);
  }

  @override
  bool shouldRepaint(_CircleVisualizerPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
