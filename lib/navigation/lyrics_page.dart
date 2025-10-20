import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart' show rootBundle;

class LyricsPage extends StatefulWidget {
  const LyricsPage({super.key});

  @override
  State<LyricsPage> createState() => _LyricsPageState();
}

enum RepeatMode { off, all, one }

class _LyricsPageState extends State<LyricsPage> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isShuffle = false;
  RepeatMode _repeatMode = RepeatMode.off;

  String _lyrics = "Loading lyrics...";
  String _currentTitle = '';
  String _currentArtist = '';
  String _currentMusicUrl = '';

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  List<Map<String, String>> _songs = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _player.onDurationChanged.listen((d) => setState(() => _duration = d));
    _player.onPositionChanged.listen((p) => setState(() => _position = p));

    _player.onPlayerComplete.listen((_) => _handleSongEnd());
    
  }

  @override
  void dispose() {
    //_player.dispose();
    super.dispose();
  }

void _handleSongEnd() async {
  if (_repeatMode == RepeatMode.one) {
    // 🔁 Repeat the same song from the start (with small delay to fix no sound)
    await _player.stop();
    await Future.delayed(const Duration(milliseconds: 200));
    final sourcePath = _currentMusicUrl.replaceFirst('assets/', '');
    await _player.play(AssetSource(sourcePath));
    setState(() => _isPlaying = true);
  } else if (_repeatMode == RepeatMode.all || _isShuffle) {
    _playNextSong();
  } else {
    setState(() => _isPlaying = false);
  }
}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    _songs = (args['songs'] as List).cast<Map<String, String>>();
    _currentIndex = args['index'] ?? 0;
    final song = _songs[_currentIndex];

    _currentTitle = song['title'] ?? '';
    _currentArtist = song['artist'] ?? '';
    _currentMusicUrl = song['musicUrl'] ?? '';

    _loadLyrics(_currentTitle);
    _playCurrentSong();
  }

  Future<void> _loadLyrics(String title) async {
    try {
      final filename = title.toLowerCase().replaceAll(" ", "_");
      final data = await rootBundle.loadString('assets/lyrics/$filename.txt');
      setState(() => _lyrics = data);
    } catch (e) {
      setState(() => _lyrics = "Lyrics not found for $title.");
    }
  }

  Future<void> _playCurrentSong() async {
    await _player.stop();
    final sourcePath = _currentMusicUrl.replaceFirst('assets/', '');
    await _player.play(AssetSource(sourcePath));
    setState(() => _isPlaying = true);
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.resume();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  void _playNextSong() {
    setState(() {
      if (_isShuffle) {
        _currentIndex = Random().nextInt(_songs.length);
      } else {
        _currentIndex = (_currentIndex + 1) % _songs.length;
      }
    });
    _updateSong();
  }

  void _playPreviousSong() {
    setState(() {
      if (_isShuffle) {
        _currentIndex = Random().nextInt(_songs.length);
      } else {
        _currentIndex =
            (_currentIndex - 1 + _songs.length) % _songs.length; // wrap around
      }
    });
    _updateSong();
  }

  void _updateSong() {
    final song = _songs[_currentIndex];
    _currentTitle = song['title'] ?? '';
    _currentArtist = song['artist'] ?? '';
    _currentMusicUrl = song['musicUrl'] ?? '';
    _loadLyrics(_currentTitle);
    _playCurrentSong();
  }

  void _toggleRepeat() {
    setState(() {
      if (_repeatMode == RepeatMode.off) {
        _repeatMode = RepeatMode.all;
      } else if (_repeatMode == RepeatMode.all) {
        _repeatMode = RepeatMode.one;
      } else {
        _repeatMode = RepeatMode.off;
      }
    });
  }

  void _toggleShuffle() {
    setState(() => _isShuffle = !_isShuffle);
  }

  String _formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  IconData _repeatIcon() {
    switch (_repeatMode) {
      case RepeatMode.off:
        return Icons.repeat;
      case RepeatMode.all:
        return Icons.repeat;
      case RepeatMode.one:
        return Icons.repeat_one;
    }
  }

  Color _repeatColor() {
    return _repeatMode == RepeatMode.off ? Colors.white70 : const Color.fromARGB(255, 56, 236, 149);
  }

 @override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      // when user presses back, just pop and return data (don’t stop music)
      Navigator.pop(context, {
        'player': _player,
        'isPlaying': _isPlaying,
        'title': _currentTitle,
        'artist': _currentArtist,
      });
      return false; // prevent auto-dispose
    },
    child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 47, 40, 40),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 22, 22, 22),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 16, 18, 16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    _currentTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "by $_currentArtist",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(179, 255, 255, 255),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Lyrics
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 16, 18, 16),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _lyrics,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 23),

            // Progress Bar
            Column(
              children: [
                Slider(
                  activeColor: const Color.fromARGB(255, 253, 252, 255),
                  inactiveColor: const Color.fromARGB(59, 248, 241, 241),
                  value: _position.inSeconds.toDouble().clamp(
                        0,
                        _duration.inSeconds.toDouble() > 0
                            ? _duration.inSeconds.toDouble()
                            : 1,
                      ),
                  max: _duration.inSeconds.toDouble() > 0
                      ? _duration.inSeconds.toDouble()
                      : 1,
                  onChanged: (value) async {
                    final newPos = Duration(seconds: value.toInt());
                    await _player.seek(newPos);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatTime(_position),
                        style: const TextStyle(color: Colors.white70)),
                    Text(_formatTime(_duration),
                        style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            
            // Spotify-style Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(_repeatIcon(), color: _repeatColor()),
                  onPressed: _toggleRepeat, iconSize: 30,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.white),
                  iconSize: 50,
                  onPressed: _playPreviousSong,
                ),
                InkWell(
                  onTap: _togglePlay,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 56, 236, 149),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      size: 55,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                  iconSize: 50,
                  onPressed: _playNextSong,
                ),
                IconButton(
                  icon: Icon(
                    Icons.shuffle,
                    color: _isShuffle ? const Color.fromARGB(255, 56, 236, 149) : const Color.fromARGB(179, 248, 247, 247),
                  ),
                  iconSize: 30,
                  onPressed: _toggleShuffle,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
    );
  }
}