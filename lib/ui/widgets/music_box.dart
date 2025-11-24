import 'package:flutter/material.dart';

class MusicBox extends StatelessWidget {
  MusicBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Colors.blue,
      child: Center(
        child: Text("Music Box"),
      )
    );
  }
}
