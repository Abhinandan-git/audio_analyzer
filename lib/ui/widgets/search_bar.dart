import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

/// Search bar widget for finding songs via YouTube API
class Search extends StatelessWidget {
  final Function(String videoId, String title)? onSongSelected;

  const Search({super.key, this.onSongSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: _SearchBar(onSongSelected: onSongSelected),
    );
  }
}

/// Search bar with YouTube API integration
class _SearchBar extends StatefulWidget {
  final Function(String videoId, String title)? onSongSelected;

  const _SearchBar({this.onSongSelected});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<YouTubeVideo> _searchResults = [];
  bool _isLoading = false;
  bool _showResults = false;
  Timer? _debounceTimer;
  OverlayEntry? _overlayEntry;

  // TODO: Replace with your YouTube Data API v3 key
  static const String _youtubeApiKey = 'YOUR_YOUTUBE_API_KEY_HERE';
  static const String _youtubeSearchEndpoint =
      'https://www.googleapis.com/youtube/v3/search';

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel();
    _removeOverlay();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus && _searchResults.isNotEmpty) {
      _showOverlay();
    } else {
      // Delay removal to allow clicking on results
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!_focusNode.hasFocus) {
          _removeOverlay();
        }
      });
    }
  }

  Future<void> _searchYouTube(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _showResults = false;
      });
      _removeOverlay();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final uri = Uri.parse(_youtubeSearchEndpoint).replace(
        queryParameters: {
          'part': 'snippet',
          'q': '$query music',
          'type': 'video',
          'videoCategoryId': '10', // Music category
          'maxResults': '10',
          'key': _youtubeApiKey,
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List;

        setState(() {
          _searchResults = items
              .map((item) => YouTubeVideo.fromJson(item))
              .toList();
          _showResults = true;
          _isLoading = false;
        });

        if (_focusNode.hasFocus) {
          _showOverlay();
        }
      } else {
        setState(() {
          _isLoading = false;
          _searchResults = [];
        });
        _showErrorSnackBar('Failed to search: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _searchResults = [];
      });
      _showErrorSnackBar('Error: $e');
    }
  }

  void _onSearchChanged(String value) {
    // Debounce search to avoid too many API calls
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchYouTube(value);
    });
  }

  void _onSongSelected(YouTubeVideo video) {
    setState(() {
      _searchController.text = video.title;
      _showResults = false;
    });
    _removeOverlay();
    _focusNode.unfocus();

    // Callback to parent widget
    widget.onSongSelected?.call(video.videoId, video.title);
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showOverlay() {
    _removeOverlay();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5,
        width: size.width,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildSearchResults(),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_searchResults.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text('No results found', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final video = _searchResults[index];
        return _SearchResultTile(
          video: video,
          onTap: () => _onSongSelected(video),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      focusNode: _focusNode,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Search for songs...',
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchResults = [];
                    _showResults = false;
                  });
                  _removeOverlay();
                },
              )
            : _isLoading
            ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
      ),
    );
  }
}

/// Search result tile widget
class _SearchResultTile extends StatelessWidget {
  final YouTubeVideo video;
  final VoidCallback onTap;

  const _SearchResultTile({required this.video, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                video.thumbnailUrl,
                width: 80,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 60,
                    color: Colors.grey[300],
                    child: const Icon(Icons.music_note, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            // Title and channel
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video.channelTitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.play_circle_outline, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}

/// YouTube video model
class YouTubeVideo {
  final String videoId;
  final String title;
  final String channelTitle;
  final String thumbnailUrl;
  final String description;

  YouTubeVideo({
    required this.videoId,
    required this.title,
    required this.channelTitle,
    required this.thumbnailUrl,
    required this.description,
  });

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] as Map<String, dynamic>;
    final thumbnails = snippet['thumbnails'] as Map<String, dynamic>;

    return YouTubeVideo(
      videoId: json['id']['videoId'] as String,
      title: snippet['title'] as String,
      channelTitle: snippet['channelTitle'] as String,
      thumbnailUrl: thumbnails['medium']['url'] as String,
      description: snippet['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'title': title,
      'channelTitle': channelTitle,
      'thumbnailUrl': thumbnailUrl,
      'description': description,
    };
  }
}
