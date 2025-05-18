import 'package:expence_tracker/core/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreenViewModel with ChangeNotifier {
  Future<void> onLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        AppUtils.showSnackbar(
          context,
          message: "Login successful",
          bgColor: Colors.green,
        );
      }
    } on FirebaseAuthException catch (e) {
      AppUtils.showSnackbar(context, message: e.code, bgColor: Colors.green);
    }
  }
}
