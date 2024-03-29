import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double width;
  final double height;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width = double.maxFinite,
    this.height = 40,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (!isLoading) ? onPressed : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isLoading) ...[
            SizedBox(
              width: height * 0.5,
              height: height * 0.5,
              child: const CircularProgressIndicator(),
            ),
            const SizedBox(width: 8),
          ],
          Text(text),
        ],
      ),
      style: ElevatedButton.styleFrom(fixedSize: Size(width, height)),
    );
  }
}
