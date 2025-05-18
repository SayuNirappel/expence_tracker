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

  static colorPick({required double amount}) {
    Color picked = Colors.white;
    amount > 5000
        ? picked = Colors.red
        : amount > 2000
            ? picked = Colors.amber
            : amount > 1000
                ? picked = Colors.lightBlueAccent
                : picked = Colors.green;
    return picked;
  }
}
