import 'package:flutter/material.dart';
import 'package:story_ku/data/pref/token_pref.dart';
import 'package:story_ku/ui/list_story/list_story_page.dart';
import 'package:story_ku/ui/login/login_page.dart';
import 'package:story_ku/ui/splash/splash_page.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;

  MyRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    var tokenPref = TokenPref();

    isLoggedIn = (await tokenPref.getToken()).isNotEmpty;
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  List<Page> historyStack = [];
  bool? isLoggedIn;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }

    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* Do Nothing */
  }

  List<Page> get _splashStack => [
        const MaterialPage(
          key: ValueKey("SplashPage"),
          child: SplashPage(),
        ),
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginPage(
            onLoginSuccess: () {
              isLoggedIn = true;
              notifyListeners();
            },
          ),
        ),
      ];

  List<Page> get _loggedInStack => [
        MaterialPage(
          key: const ValueKey("ListStoryPage"),
          child: ListStoryPage(
            onLogoutSuccess: () {
              isLoggedIn = false;
              notifyListeners();
            },
          ),
        ),
      ];
}
