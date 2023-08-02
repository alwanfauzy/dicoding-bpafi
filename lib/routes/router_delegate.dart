import 'package:flutter/material.dart';
import 'package:story_ku/ui/list_story/list_story_page.dart';
import 'package:story_ku/ui/login/login_page.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;

  MyRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  bool? isLogin;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginPage(
            onLoginSuccess: () {
              isLogin = true;
              notifyListeners();
            },
          ),
        ),
        if (isLogin != null)
          const MaterialPage(
            key: ValueKey("ListStoryPage"),
            child: ListStoryPage(),
          ),
      ],
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        isLogin = null;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* Do Nothing */
  }
}
