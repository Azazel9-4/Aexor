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
      title: 'Aexor',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black87,
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/lyrics': (context) => const LyricsPage(),
      },

      // Smooth fade transition for LyricsPage
      onGenerateRoute: (settings) {
        if (settings.name == '/lyrics') {
          return PageRouteBuilder(
            settings: settings,
            transitionDuration: const Duration(milliseconds: 450),
            pageBuilder: (_, animation, __) =>
                FadeTransition(opacity: animation, child: const LyricsPage()),
          );
        }
        return null;
      },
    );
  }
}
