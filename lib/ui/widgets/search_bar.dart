import 'package:flutter/material.dart';

// Search bar widget, no state needed (check)
class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: _SearchBar()
    );
  }
}

// Search bar widget, state needed
class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  @override
  Widget build(BuildContext context) {
    // text box for searching
    return TextField(
      decoration: InputDecoration(
        // placeholder
        hintText: "Search",
        // icon
        prefixIcon: Icon(Icons.search),
        // border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        // color fill
        filled: true,
        fillColor: Colors.grey[250],
      ),
    );
  }
}
