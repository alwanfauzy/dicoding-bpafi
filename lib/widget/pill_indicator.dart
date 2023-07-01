import 'package:flutter/material.dart';

class PillIndicator extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;

  const PillIndicator({
    super.key,
    this.width = 100,
    this.height = 5,
    this.margin = const EdgeInsets.only(top: 8, bottom: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: Theme.of(context).dividerColor),
    );
  }
}
