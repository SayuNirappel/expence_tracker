import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expence_tracker/core/utils/app_utils.dart';
import 'package:expence_tracker/feartures/add_screen/view/add_screen.dart';
import 'package:expence_tracker/feartures/search_screen/view/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
            icon: Icon(Icons.search),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () async {
              // loggout  using in built function
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(user!.uid)
              .collection("expenses")
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went Wrong");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            final docs = snapshot.data!.docs;
// finding todays total
            double todaysTotal = 0;
            final now = DateTime.now();
            for (var doc in docs) {
              final timestamp = (doc["timestamp"] as Timestamp).toDate();
              if (timestamp.year == now.year &&
                  timestamp.month == now.month &&
                  timestamp.day == now.day) {
                todaysTotal += (doc["amount"] as num).toDouble();
              }
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.deepOrange)),
                      child: Column(
                        children: [
                          Text(
                            "Today",
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                          Text(
                            "$todaysTotal",
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 50),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //list of expense
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
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            border: Border.all(
                                color: AppUtils.colorPick(amount: amount),
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              amount.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppUtils.colorPick(amount: amount),
                                  fontSize: 30),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  "${category} : ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${dandt.day.toString()}/${dandt.month.toString()}/${dandt.year.toString()} ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }, childCount: docs.length))
              ],
            );
          }),
    );
  }
}
