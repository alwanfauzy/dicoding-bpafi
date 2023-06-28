import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:story_ku/ui/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final theme = await initializeTheme();

  runApp(MyApp(theme: theme));
}

Future<ThemeData?> initializeTheme() async {
  final themeStr = await rootBundle.loadString('assets/storyku_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson);

  return theme;
}

class MyApp extends StatelessWidget {
  final ThemeData? theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StoryKu',
      theme: theme,
      home: const LoginPage(),
    );
  }
}
