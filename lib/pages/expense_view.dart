import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matespendsapp/services/expense_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import for formatting

class ExpenseView extends StatefulWidget {
  final String title;
  final int cost;
  final String category;
  final String note;
  final String expenseId;
  final String userId;

  const ExpenseView({
    super.key,
    required this.title,
    required this.cost,
    required this.category,
    required this.note,
    required this.expenseId,
    required this.userId,
  });

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  late String userId;
  final formatter = NumberFormat('#,##0', 'en_US'); // Formatter for currency

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  //Future<void> _editExpense(
  //    String title, int? cost, String category, String? note) async {
  //  try {
  //    if (title.isEmpty || cost == null || category.isEmpty) {
  //      ScaffoldMessenger.of(context).showSnackBar(
  //        const SnackBar(content: Text('Please fill in all required fields')),
  //      );
  //      return;
  //    }
  //
  //    await _firebaseService.editExpense(widget.expenseId, {
  //      'title': title,
  //      'cost': cost,
  //      'category': category,
  //      'note': note,
  //    });
  //
  //    if (mounted) {
  //      ScaffoldMessenger.of(context).showSnackBar(
  //        const SnackBar(content: Text('Expense updated successfully!')),
  //      );
  //      Navigator.pop(context); // Close dialog after update
  //    }
  //  } catch (e) {
  //    print('Error editing expense: $e');
  //    if (mounted) {
  //      ScaffoldMessenger.of(context).showSnackBar(
  //        SnackBar(content: Text('Error editing expense: $e')),
  //      );
  //    }
  //  }
  //}

  void _editExpense(
      String expenseId, String title, int? cost, String category, String note) {
    context
        .read<ExpenseProvider>()
        .editExpense(expenseId, title, cost, category, note);
  }

  void _showEditExpenseDialog(BuildContext context) {
    final TextEditingController expenseTitleController =
        TextEditingController(text: widget.title);
    final TextEditingController expenseCostController =
        TextEditingController(text: widget.cost.toString());
    final TextEditingController expenseNoteController =
        TextEditingController(text: widget.note);
    List<String> categories = [
      "Food and Drinks",
      "Transportation",
      "Education",
      "Housing and Utilities",
      "Entertainment and Social Activities"
    ];
    String selectedCategory = widget.category;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Color(0xFF60BD8A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8),
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Add Expense",
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Expense title*",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: expenseTitleController,
                        decoration: InputDecoration(
                          hintText: "Enter expense title",
                          filled: true,
                          fillColor: Color(0xFFFFFFFF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle:
                              TextStyle(color: Color(0xFF282828), fontSize: 14),
                        ),
                        style:
                            TextStyle(color: Color(0xFF282828), fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Expense total cost*",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: expenseCostController,
                        decoration: InputDecoration(
                          hintText: "Enter expense total cost",
                          filled: true,
                          fillColor: Color(0xFFFFFFFF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle:
                              TextStyle(color: Color(0xFF282828), fontSize: 14),
                        ),
                        style:
                            TextStyle(color: Color(0xFF282828), fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Expense category*",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown:
                              true, // Aligns the dropdown menu with the button
                          child: DropdownButtonFormField<String>(
                            value: selectedCategory,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFFFFFFF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: categories.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category,
                                  style: TextStyle(
                                      color: Color(0xFF282828),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              selectedCategory = newValue!;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Expense Note",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: expenseNoteController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Enter expense note (optional)",
                          filled: true,
                          fillColor: Color(0xFFFFFFFF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle:
                              TextStyle(color: Color(0xFF282828), fontSize: 14),
                        ),
                        style:
                            TextStyle(color: Color(0xFF282828), fontSize: 14),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Color(0xFFFFFFFF)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          int? cost = int.tryParse(expenseCostController.text);
                          if (cost == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Please enter a valid number")));
                          }
                          _editExpense(
                            widget.expenseId,
                            expenseTitleController.text,
                            cost,
                            selectedCategory,
                            expenseNoteController.text,
                          );
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            color: Color(0xFF282828),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width, // More control over width
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF60BD8A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      "Rp.${formatter.format(widget.cost)}",
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    Text(
                      widget.category,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 20, color: Colors.white),
                    onPressed: () => _showEditExpenseDialog(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "Note:",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              widget.note,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Color(0xFFFFFFFF)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
