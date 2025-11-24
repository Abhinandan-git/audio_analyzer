import 'package:flutter/material.dart';

// check if state is needed
class Visualizer extends StatelessWidget {
  Visualizer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500 ,
      color: Colors.lightBlue,
      // set to middle
      alignment: Alignment.center,
      child: Center(
        // change to middle circle
        child: Container(
          height: 150,
          width: 150,
          color: Colors.amber,
          child: _VisualizerCircleCanvas(),
        ),
      )
    );
  }
}

// no state needed
class _VisualizerCircleCanvas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _VisualizerCircle(),
    );
  }
}

// check CustomPainter and CustomPaint
class _VisualizerCircle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
