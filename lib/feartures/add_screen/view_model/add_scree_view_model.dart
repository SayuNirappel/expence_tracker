import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expence_tracker/core/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddScreenViewModel extends ChangeNotifier {
  final TextEditingController amountController = TextEditingController();
  String? selectedCategory;

  final formKey = GlobalKey<FormState>();

  void setCategory(String? value) {
    selectedCategory = value;
    notifyListeners();
  }

  Future<void> addExpense(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        AppUtils.showSnackbar(context, message: "User not logged in");
        return;
      }

      final amount = double.tryParse(amountController.text.trim());
      final category = selectedCategory;

      if (amount == null || category == null) {
        AppUtils.showSnackbar(context, message: "Invalid input");
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('expenses')
          .add({
        'amount': amount,
        'category': category,
        'timestamp': FieldValue.serverTimestamp(),
      });

      AppUtils.showSnackbar(context, message: "Expense Added");
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}
