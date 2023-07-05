import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:json_theme/json_theme.dart';
import 'package:story_ku/data/pref/token_pref.dart';
import 'package:story_ku/ui/list_story/list_story_page.dart';
import 'package:story_ku/ui/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final theme = await initializeTheme();
  final token = await checkToken();

  runApp(MyApp(theme: theme, token: token));

  configLoading();
}

Future<ThemeData?> initializeTheme() async {
  final themeStr = await rootBundle.loadString('assets/storyku_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson);

  return theme;
}

Future<String> checkToken() async {
  var tokenPref = TokenPref();

  return await tokenPref.getToken();
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
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  final ThemeData? theme;
  final String token;

  const MyApp({Key? key, required this.theme, required this.token})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StoryKu',
      theme: theme,
      home: (token.isEmpty) ? const LoginPage() : const ListStoryPage(),
      builder: EasyLoading.init(),
    );
  }
}
