import 'package:expence_tracker/core/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreenViewModel with ChangeNotifier {
  Future<void> onRegister({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        AppUtils.showSnackbar(
          context,
          message: "User registration successful",
          bgColor: Colors.green,
        );

        // on success to HomeScreen and pop all other screens
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } on FirebaseAuthException catch (e) {
      //error messages
      if (e.code == 'weak-password') {
        AppUtils.showSnackbar(
          context,
          message: 'The password provided is too weak.',
        );
      } else if (e.code == 'email-already-in-use') {
        AppUtils.showSnackbar(
          context,
          message: 'The account already exists for that email.',
        );
      }
    } catch (e) {
      // print any other exceptions
      AppUtils.showSnackbar(context, message: e.toString());
    }
  }
}
