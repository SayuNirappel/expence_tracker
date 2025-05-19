import 'package:expence_tracker/feartures/add_screen/view_model/add_scree_view_model.dart';
import 'package:expence_tracker/shared/lists/category_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = CategoryList().categories;

    return ChangeNotifierProvider(
      create: (_) => AddScreenViewModel(),
      child: Consumer<AddScreenViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Add New Expense",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: model.formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: model.selectedCategory,
                      items: categories
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: model.setCategory,
                      decoration: InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null ? "Select a Category" : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: model.amountController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: "Amount",
                        hintText: "Enter amount in numbers",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Enter amount";
                        }
                        if (double.tryParse(value.trim()) == null) {
                          return "Enter a valid number";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => model.addExpense(context),
                      child: Text(
                        "Add Expense",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
