import 'package:audio_analyzer/ui/widgets/music_box.dart';
import 'package:audio_analyzer/ui/widgets/search_bar.dart';
import 'package:audio_analyzer/ui/widgets/visualizer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

/// Main app, no state management at top most level
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _currentVideoId;
  String? _currentSongTitle;

  void _onSongSelected(String videoId, String title) {
    setState(() {
      _currentVideoId = videoId;
      _currentSongTitle = title;
    });

    // Show feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loading: $title'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Search bar - 10% of screen
            Expanded(
              flex: 10,
              child: Search(
                onSongSelected: _onSongSelected,
              ),
            ),
            // Visualizer - 75% of screen
            Expanded(
              flex: 75,
              child: Visualizer(),
            ),
            // Music box - 15% of screen
            Expanded(
              flex: 15,
              child: MusicBox(),
            ),
          ],
        ),
      ),
    );
  }
}