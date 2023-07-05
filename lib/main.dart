import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:json_theme/json_theme.dart';
import 'package:story_ku/ui/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final theme = await initializeTheme();

  runApp(MyApp(theme: theme));

  configLoading();
}

Future<ThemeData?> initializeTheme() async {
  final themeStr = await rootBundle.loadString('assets/storyku_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson);

  return theme;
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..
    ..dismissOnTap = false;
    
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
      builder: EasyLoading.init(),
    );
  }
}
