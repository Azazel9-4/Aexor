import 'package:flutter/material.dart';
import 'navigation/home_page.dart';
import 'navigation/lyrics_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Song Lyrics Display',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black87, // dark background
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/lyrics': (context) => const LyricsPage(),
      },
      onGenerateRoute: (settings) {
        // Handle possible errors when routing, for example invalid arguments
        if (settings.name == '/lyrics') {
          final Map<String, String> song = settings.arguments as Map<String, String>;
          if (song.isEmpty) {
            return _errorRoute();
          }
        }
        return null;
      },
    );
  }
  // Define an error route for invalid arguments
  MaterialPageRoute _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text(
            'Failed to load song data.',
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      ),
    );
  }
}