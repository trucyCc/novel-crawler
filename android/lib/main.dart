import 'package:android/screens/chapter.dart';
import 'package:android/screens/home.dart';
import 'package:android/screens/novel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  useMaterial3: true,
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: theme,
        routes: {
          "/novel": (context) => NovelScreen(),
          "/novel/chapter": (context) => ChapterScreen()
        },
        home: const HomeScreen());
  }
}
