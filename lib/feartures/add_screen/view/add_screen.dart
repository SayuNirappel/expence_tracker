import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expence_tracker/core/utils/app_utils.dart';
import 'package:expence_tracker/shared/lists/category_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  String? selectedCategory;
  final List<String> categories = CategoryList().categories;

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    final TextEditingController amountcontroller = TextEditingController();

    @override
    void dispose() {
      amountcontroller.dispose();
      super.dispose();
    }

    Future<void> addExp() async {
      if (formkey.currentState!.validate()) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User not logged in")),
          );
          return;
        }

        final amount = double.tryParse(amountcontroller.text.trim());
        final category = selectedCategory;

        if (amount == null || category == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid input")),
          );
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
        //delay for snack bar and fb updation
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
        // Close the form screen
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add New Expense",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
            key: formkey,
            child: Column(
              spacing: 20,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: categories
                      .map((category) => DropdownMenuItem(
                          value: category, child: Text(category)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Catergory",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null ? "Select a Category" : null,
                ),
                TextFormField(
                  controller: amountcontroller,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      labelText: "Amount",
                      hintText: "Enter Amount in numbers",
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter Amount";
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return "Enter a valid number";
                    }
                    return null;
                  },
                ),
                ElevatedButton(onPressed: addExp, child: Text("Add Expense"))
              ],
            )),
      ),
    );
  }
}
