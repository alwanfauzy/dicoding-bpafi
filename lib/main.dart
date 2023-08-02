import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:json_theme/json_theme.dart';
import 'package:story_ku/data/pref/token_pref.dart';
import 'package:story_ku/routes/router_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeCerts();
  final theme = await initializeTheme();

  runApp(MyApp(theme: theme));

  configLoading();
}

Future<void> initializeCerts() async {
  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());
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
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  final ThemeData? theme;

  const MyApp({Key? key, required this.theme})
      : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyRouterDelegate _myRouterDelegate;

  @override
  void initState() {
    super.initState();
    _myRouterDelegate = MyRouterDelegate();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StoryKu',
      theme: widget.theme,
      // home: (widget.token.isEmpty) ? const LoginPage() : const ListStoryPage(),
      home: Router(
        routerDelegate: _myRouterDelegate,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
      builder: EasyLoading.init(),
    );
  }
}
