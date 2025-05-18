import 'package:expence_tracker/feartures/add_screen/view/add_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddScreen()));
        },
        focusColor: Colors.red,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          "Expense Tracker",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
