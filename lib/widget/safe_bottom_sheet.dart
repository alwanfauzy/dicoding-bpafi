import 'package:flutter/material.dart';
import 'package:story_ku/widget/pill_indicator.dart';

class SafeBottomSheet extends StatelessWidget {
  final List<Widget> children;
  final Radius radius;

  const SafeBottomSheet({
    super.key,
    required this.children,
    this.radius = const Radius.circular(16),
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    widgets.add(const PillIndicator());
    widgets.addAll(children);

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
              topLeft: radius,
              topRight: radius,
            )),
        padding: EdgeInsets.only(
            left: 32,
            right: 32,
            bottom: 32 + MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widgets,
        ),
      ),
    );
  }
}
