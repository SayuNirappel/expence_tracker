import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expence_tracker/core/utils/app_utils.dart';
import 'package:expence_tracker/feartures/add_screen/view/add_screen.dart';
import 'package:expence_tracker/feartures/home_screen/view_model/home_screen_view_model.dart';
import 'package:expence_tracker/feartures/search_screen/view/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeScreenViewModel>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddScreen()));
        },
        child: Icon(
          Icons.add,
          color: Colors.red,
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Expense Tracker",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
            icon: Icon(
              Icons.search,
              color: Colors.red,
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.person,
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder(
        stream: viewModel.expenseStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Text("Something went wrong");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          final todaysTotal = viewModel.calculateTodaysTotal(docs);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.deepPurple, width: 3),
                    ),
                    child: Column(
                      children: [
                        Text("Today",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                        Text(
                          "$todaysTotal",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final doc = docs[index];
                  final amount = doc['amount'];
                  final category = doc['category'];
                  final dandt = (doc["timestamp"] as Timestamp).toDate();

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            border: Border.all(
                              color: AppUtils.colorPick(amount: amount),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              amount.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppUtils.colorPick(amount: amount),
                                fontSize: 30,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  "$category : ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${dandt.day}/${dandt.month}/${dandt.year}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                viewModel.deleteExpense(doc.id);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }, childCount: docs.length),
              ),
            ],
          );
        },
      ),
    );
  }
}
