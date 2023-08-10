import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:provider/provider.dart';
import 'package:story_ku/provider/localization_provider.dart';
import 'package:story_ku/routes/page_manager.dart';
import 'package:story_ku/routes/router_delegate.dart';

import 'common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeCerts();
  final theme = await initializeTheme();

  runApp(MyApp(theme: theme));
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

class MyApp extends StatefulWidget {
  final ThemeData? theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocalizationProvider>(
          create: (context) => LocalizationProvider(),
        ),
        ChangeNotifierProvider<PageManager>(
          create: (context) => PageManager(),
        ),
      ],
      builder: (context, child) {
        final localizationProvider = Provider.of<LocalizationProvider>(context);

        return MaterialApp(
          title: 'StoryKu',
          theme: widget.theme,
          home: Router(
            routerDelegate: _myRouterDelegate,
            backButtonDispatcher: RootBackButtonDispatcher(),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: localizationProvider.locale,
        );
      },
    );
  }
}
