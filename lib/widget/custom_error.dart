import 'package:flutter/material.dart';
import 'package:story_ku/common.dart';
import 'package:story_ku/widget/primary_button.dart';

class CustomError extends StatelessWidget {
  final String message;
  final VoidCallback onRefresh;

  const CustomError(
      {super.key, required this.message, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 8),
          PrimaryButton(
            onPressed: onRefresh,
            text: AppLocalizations.of(context)!.buttonReload,
          ),
        ],
      ),
    );
  }
}
