// home_screen_view_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser;

  Stream<QuerySnapshot> get expenseStream {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("expenses")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  double calculateTodaysTotal(List<QueryDocumentSnapshot> docs) {
    double total = 0;
    final now = DateTime.now();

    for (var doc in docs) {
      final timestamp = (doc["timestamp"] as Timestamp).toDate();
      if (timestamp.year == now.year &&
          timestamp.month == now.month &&
          timestamp.day == now.day) {
        total += (doc["amount"] as num).toDouble();
      }
    }
    return total;
  }

  Future<void> deleteExpense(String docId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("expenses")
        .doc(docId)
        .delete();
  }
}
