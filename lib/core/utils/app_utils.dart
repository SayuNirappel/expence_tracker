import 'package:flutter/material.dart';

class AppUtils {
  static showSnackbar(
    BuildContext context, {
    required String message,
    Color bgColor = Colors.red,
  }) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: bgColor));
  }
}
