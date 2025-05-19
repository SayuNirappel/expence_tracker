import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expence_tracker/core/utils/app_utils.dart';
import 'package:expence_tracker/feartures/search_screen/view_model/search_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //controller
    final viewModel = context.watch<SearchScreenViewModel>();

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            "Search",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 20,
          children: [
            DropdownButtonFormField<String>(
              value: viewModel.selectedCategory,
              hint: Text("Select Category"),
              items: viewModel.categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                context.read<SearchScreenViewModel>().selectedCategory = value;
              },
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            Text(viewModel.selectedDate == null
                ? "No Date Chosen"
                : "${viewModel.selectedDate!.day}/${viewModel.selectedDate!.month}/${viewModel.selectedDate!.year}"),
            TextButton.icon(
              onPressed: () => viewModel.pickDate(context),
              icon: Icon(Icons.calendar_month),
              label: Text("Pick Date",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            ),
            //SizedBox(height: 20),
            ElevatedButton.icon(
              style: ButtonStyle(),
              onPressed: () => viewModel.performSearch(),
              icon: Icon(Icons.search),
              label: Text("Search",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
            ),
            SizedBox(height: 20),
            Expanded(
              child: viewModel.results.isEmpty
                  ? Text(
                      "No results found !",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                          fontSize: 20),
                    )
                  : ListView.builder(
                      itemCount: viewModel.results.length,
                      itemBuilder: (context, index) {
                        final doc = viewModel.results[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final amount = data['amount'];
                        final category = data['category'];
                        //converting timestamp for accessing day,month,year
                        final timestamp =
                            (data["timestamp"] as Timestamp).toDate();

                        return Container(
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
                            subtitle: Text(
                                "$category | ${timestamp.day}/${timestamp.month}/${timestamp.year}"),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
