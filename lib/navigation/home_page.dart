import 'package:flutter/material.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, String>> songs = const [
    {
      'title': 'About You',
      'artist': 'The 1975',
      'musicUrl': 'assets/songs/about_you.mp3',
      'lyricsUrl': 'assets/lyrics/about_you.txt',
    },
    {
      'title': 'The Only Exception',
      'artist': 'Paramore',
      'musicUrl': 'assets/songs/the_only_exception.mp3',
      'lyricsUrl': 'assets/lyrics/the_only_exception.txt',
    },
    {
      'title': 'Robbers',
      'artist': 'The 1975',
      'musicUrl': 'assets/songs/robbers.mp3',
      'lyricsUrl': 'assets/lyrics/Robbers.txt',
    },
    {
      'title': 'August',
      'artist': 'Taylor Swift',
      'musicUrl': 'assets/songs/august.mp3',
      'lyricsUrl': 'assets/lyrics/august.txt',
    },
    {
      'title': 'Cardigan',
      'artist': 'Taylor Swift',
      'musicUrl': 'assets/songs/cardigan.mp3',
      'lyricsUrl': 'assets/lyrics/cardigan.txt',
    },
    {
      'title': 'Lover',
      'artist': 'Taylor Swift ft. Shawn Mendes ',
      'musicUrl': 'assets/songs/lover.mp3',
      'lyricsUrl': 'assets/lyrics/lover.txt',
    },
    {
      'title': 'Falling',
      'artist': 'Harry Styles',
      'musicUrl': 'assets/songs/falling.mp3',
      'lyricsUrl': 'assets/lyrics/falling.txt',
    },
    {
      'title': 'Birds of a Feather',
      'artist': 'Billie Eilish',
      'musicUrl': 'assets/songs/birds_of_a_feather.mp3',
      'lyricsUrl': 'assets/lyrics/birds_of_a_feather.txt',
    },
    {
      'title': 'So High School',
      'artist': 'Taylor Swift',
      'musicUrl': 'assets/songs/so_high_school.mp3',
      'lyricsUrl': 'assets/lyrics/so_high_school.txt',
    },
    {
      'title': 'Balisong',
      'artist': 'Rico Blanco',
      'musicUrl': 'assets/songs/balisong.mp3',
      'lyricsUrl': 'assets/lyrics/balisong.txt',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 30, 30),
      appBar: AppBar(
          title: const Text(
          'Aexor',
          style: TextStyle(
            fontFamily: 'Roboto', fontSize: 26, fontWeight: FontWeight.bold,color: Colors.greenAccent, letterSpacing: 1.5,),
        ),
        backgroundColor: const Color.fromARGB(255, 22, 22, 22),
        centerTitle: true,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/lyrics',
                arguments: {
                  'songs': songs,
                  'index': index,
                },
              );
            },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.music_note, color: Color.fromARGB(255, 56, 236, 149)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song['title'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'by ${song['artist'] ?? 'Unknown Artist'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 198, 187, 187),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}