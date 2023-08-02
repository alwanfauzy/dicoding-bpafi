import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// todo 13: create SplashScreen
class SplashPage extends StatelessWidget {
  const SplashPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/storyku.svg',
              width: 100,
              height: 100,
            ),
            Text(
              "StoryKu",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
