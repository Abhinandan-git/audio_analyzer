import 'package:audio_analyzer/ui/widgets/music_box.dart';
import 'package:audio_analyzer/ui/widgets/search_bar.dart';
import 'package:audio_analyzer/ui/widgets/visualizer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

// Main app, no state management at top most level
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // Area for notch
        body: SafeArea(
          child: Column(
            children: <Widget>[
              // Search bar
              Expanded(
                flex: 10,
                child: Search()
              ),
              // Visualizer
              Expanded(
                flex: 75,
                child: Visualizer()
              ),
              // Music box
              Expanded(
                flex: 15,
                child: MusicBox()
              ),
            ],
          ),
        ),
      ),
    );
  }
}
