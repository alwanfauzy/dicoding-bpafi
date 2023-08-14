import 'package:flutter/material.dart';

class SafeScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final FloatingActionButton? fab;
  final ScrollController? scrollController;

  const SafeScaffold(
      {super.key,
      required this.body,
      this.appBar,
      this.fab,
      this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: fab,
      body: SafeArea(
          child: SingleChildScrollView(
        child: body,
        controller: scrollController,
      )),
    );
  }
}
