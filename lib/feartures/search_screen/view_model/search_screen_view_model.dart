import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expence_tracker/shared/lists/category_list.dart';

class SearchScreenViewModel extends ChangeNotifier {
  String? selectedCategory;
  DateTime? selectedDate;
  List<DocumentSnapshot> results = [];

  final categories = CategoryList().categories;

  // Pick date using context passed from the UI
  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      selectedDate = picked;
      notifyListeners();
    }
  }

  // Perform Firebase search based on selected category/date
  Future<void> performSearch() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Setting individual expense path
    Query q = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('expenses');

    // Category selection
    if (selectedCategory != null) {
      q = q.where('category', isEqualTo: selectedCategory);
    }

    // Selecting one date
    if (selectedDate != null) {
      // Starting from 00:00
      final start = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
      );
      // Gap of a day
      final end = start.add(Duration(days: 1));

      q = q
          .where('timestamp', isGreaterThanOrEqualTo: start)
          .where('timestamp', isLessThan: end);
    }

    final snapshot = await q.orderBy('timestamp', descending: true).get();
    results = snapshot.docs;
    notifyListeners();
  }
}
