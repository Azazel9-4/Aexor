import 'package:flutter/material.dart';
import '../services/player_manager.dart';
import '../services/mini_player.dart'; // Mini player

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final background = 'assets/bg/bg_icon.jpg';

  final List<Map<String, String>> songs = const [
    {
      'title': 'About You',
      'artist': 'The 1975',
      'musicUrl': 'assets/songs/about_you.mp3',
      'lyricsUrl': 'assets/lyrics/about_you.txt',
      'coverUrl': 'assets/covers/about_you.jpg',
      'albumUrl': 'assets/album_cover/about_you_album.jpg',
    },
    {
      'title': 'The Only Exception',
      'artist': 'Paramore',
      'musicUrl': 'assets/songs/the_only_exception.mp3',
      'lyricsUrl': 'assets/lyrics/the_only_exception.txt',
      'coverUrl': 'assets/covers/the_only_exception.jpg',
      'albumUrl': 'assets/album_cover/the_only_exception_album.jpg',
    },
    {
      'title': 'Robbers',
      'artist': 'The 1975',
      'musicUrl': 'assets/songs/robbers.mp3',
      'lyricsUrl': 'assets/lyrics/robbers.txt',
      'coverUrl': 'assets/covers/robbers.jpg',
      'albumUrl': 'assets/album_cover/robbers_album.jpg',
    },
    {
      'title': 'August',
      'artist': 'Taylor Swift',
      'musicUrl': 'assets/songs/august.mp3',
      'lyricsUrl': 'assets/lyrics/august.txt',
      'coverUrl': 'assets/covers/august.jpg',
      'albumUrl': 'assets/album_cover/august_album.jpg',
    },
    {
      'title': 'Cardigan',
      'artist': 'Taylor Swift',
      'musicUrl': 'assets/songs/cardigan.mp3',
      'lyricsUrl': 'assets/lyrics/cardigan.txt',
      'coverUrl': 'assets/covers/cardigan.jpg',
      'albumUrl': 'assets/album_cover/cardigan_album.jpg',
    },
    {
      'title': 'Luther',
      'artist': 'Kendrick Lamar ft. Sza',
      'musicUrl': 'assets/songs/luther.mp3',
      'lyricsUrl': 'assets/lyrics/luther.txt',
      'coverUrl': 'assets/covers/luther.jpg',
      'albumUrl': 'assets/album_cover/luther_album.jpg',
    },
    {
      'title': 'Falling',
      'artist': 'Harry Styles',
      'musicUrl': 'assets/songs/falling.mp3',
      'lyricsUrl': 'assets/lyrics/falling.txt',
      'coverUrl': 'assets/covers/falling.jpg',
      'albumUrl': 'assets/album_cover/falling_album.jpg',
    },
    {
      'title': 'Birds of a Feather',
      'artist': 'Billie Eilish',
      'musicUrl': 'assets/songs/birds_of_a_feather.mp3',
      'lyricsUrl': 'assets/lyrics/birds_of_a_feather.txt',
      'coverUrl': 'assets/covers/birds_of_a_feather.jpg',
      'albumUrl': 'assets/album_cover/birds_of_a_feather_album.jpg',
    },
    {
      'title': 'So High School',
      'artist': 'Taylor Swift',
      'musicUrl': 'assets/songs/so_high_school.mp3',
      'lyricsUrl': 'assets/lyrics/so_high_school.txt',
      'coverUrl': 'assets/covers/so_high_school.jpg',
      'albumUrl': 'assets/album_cover/so_high_school_album.jpg',
    },
    {
      'title': 'As It Was',
      'artist': 'Harry Styles',
      'musicUrl': 'assets/songs/as_it_was.mp3',
      'lyricsUrl': 'assets/lyrics/as_it_was.txt',
      'coverUrl': 'assets/covers/as_it_was.jpg',
      'albumUrl': 'assets/album_cover/as_it_was_album.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    PlayerManager.init();
  }

  void _openLyrics(int index) {
    Navigator.pushNamed(
      context,
      '/lyrics',
      arguments: {'songs': songs, 'index': index},
    );
  }

  Widget _buildSongTile(int index) {
    final song = songs[index];
    return GestureDetector(
      onTap: () {
        PlayerManager.playSong({
          ...song,
          'index': index,
          'songs': songs,
          'albumUrl': song['albumUrl'] ?? song['coverUrl'],
        });
        _openLyrics(index);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          title: Text(
            song['title'] ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
          subtitle: Text(
            song['artist'] ?? '',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Aexor',
          style: TextStyle(
            color: Color.fromARGB(255, 3, 253, 24),
            fontSize: 25,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              background,
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: songs.length,
              itemBuilder: (context, i) => _buildSongTile(i),
            ),
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }
}
