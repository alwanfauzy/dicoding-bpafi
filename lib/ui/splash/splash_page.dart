import 'package:flutter/material.dart';

/// todo 13: create SplashScreen
class SplashPage extends StatelessWidget {
  const SplashPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "StoryKu",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
