import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expence_tracker/shared/lists/category_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? selectedCategory;
  DateTime? selectedDate;
  List<DocumentSnapshot> results = [];

  final categories = CategoryList().categories;
//Date Pick
  void pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void performSearch() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    Query q = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('expenses');

    if (selectedCategory != null) {
      q = q.where('category', isEqualTo: selectedCategory);
    }

    if (selectedDate != null) {
      final start =
          DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day);
      final end = start.add(Duration(days: 1));
      q = q
          .where('timestamp', isGreaterThanOrEqualTo: start)
          .where('timestamp', isLessThan: end);
    }

    final snapshot = await q.orderBy('timestamp', descending: true).get();
    setState(() {
      results = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Search",
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dropdown for category
            DropdownButtonFormField<String>(
              value: selectedCategory,
              hint: Text("Select Category"),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedCategory = value);
              },
            ),
            SizedBox(height: 10),

            // Date picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(selectedDate == null
                    ? "No Date Chosen"
                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                TextButton.icon(
                  onPressed: pickDate,
                  icon: Icon(Icons.calendar_month),
                  label: Text("Pick Date"),
                )
              ],
            ),

            SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: performSearch,
              icon: Icon(Icons.search),
              label: Text("Search"),
            ),

            SizedBox(height: 20),

            //search results dispaly
            Expanded(
              child: results.isEmpty
                  ? Text("No results found.")
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final doc = results[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final amount = data['amount'];
                        final category = data['category'];
                        final timestamp =
                            (data['timestamp'] as Timestamp).toDate();

                        return Container(
                          child: ListTile(
                            title: Text(amount.toString()),
                            subtitle: Text(
                                "$category | ${timestamp.day}/${timestamp.month}/${timestamp.year}"),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
