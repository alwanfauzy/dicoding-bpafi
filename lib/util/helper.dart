import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

afterBuildWidgetCallback(VoidCallback callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback.call();
  });
}

showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast
        .LENGTH_SHORT, // Duration for how long the toast will be displayed (SHORT or LONG)
    gravity: ToastGravity
        .BOTTOM, // Location where the toast will be shown (TOP, CENTER, or BOTTOM)
    timeInSecForIosWeb: 1, // Duration for iOS (web) only
    backgroundColor: Colors.grey[700], // Background color of the toast
    textColor: Colors.white, // Text color of the toast
    fontSize: 16.0, // Font size of the toast text
  );
}