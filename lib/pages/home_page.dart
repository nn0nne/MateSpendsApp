import 'package:firebase_auth/firebase_auth.dart';
import 'package:matespendsapp/services/expense_provider.dart';
//import 'package:matespendsapp/services/firebase.dart';
import 'package:flutter/material.dart';
import 'package:matespendsapp/widgets/expense_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final FirebaseService _firebaseService = FirebaseService();
  late String userId;
  //List<Map<String, dynamic>> expenses = [];
  //bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    Future.microtask(
        () => context.read<ExpenseProvider>().loadExpenses(userId));
    //loadExpenses();
  }

  //Future<void> loadExpenses() async {
  //  FirebaseService firebaseService = FirebaseService();
  //  List<Map<String, dynamic>> fetchExpenses =
  //      await firebaseService.fetchExpenses();
  //
  //  List<Map<String, dynamic>> userExpenses = fetchExpenses
  //      .where((expense) => expense['createdById'] == userId)
  //      .toList();
  //
  //  if (!mounted) return;
  //
  //  setState(() {
  //    expenses = userExpenses;
  //    isLoading = false;
  //  });
  //}

  //Future<void> _addExpense(
  //    String title, int? cost, String category, String? note) async {
  //  try {
  //    if (title.isEmpty || cost == null || category.isEmpty) {
  //      ScaffoldMessenger.of(context).showSnackBar(
  //        const SnackBar(content: Text('Please fill in all required fields')),
  //      );
  //      return;
  //    }
  //
  //    String username = await _firebaseService.getUsernameById(userId);
  //
  //    if (note == "") {
  //      note = "-";
  //    }
  //
  //    // Create playlist document in Firestore with playlistId
  //    await _firebaseService.addExpense({
  //      'title': title,
  //      'cost': cost,
  //      'category': category,
  //      'note': note,
  //      'createdBy': username,
  //      'createdById': userId,
  //      'createdAt': DateTime.now().toIso8601String(),
  //    });
  //
  //    if (mounted) {
  //      loadExpenses();
  //      ScaffoldMessenger.of(context).showSnackBar(
  //        const SnackBar(
  //            content: Text('Expense have been added successfully!')),
  //      );
  //    }
  //  } catch (e) {
  //    print('Error adding expense: $e');
  //    if (mounted) {
  //      ScaffoldMessenger.of(context).showSnackBar(
  //        SnackBar(content: Text('Error adding expense: $e')),
  //      );
  //    }
  //  }
  //}

  void _addExpense(String title, int? cost, String category, String? note) {
    context
        .read<ExpenseProvider>()
        .addExpense(context, userId, title, cost, category, note);
  }

  void _showAddExpenseDialog(BuildContext context) {
    final TextEditingController expenseTitleController =
        TextEditingController();
    final TextEditingController expenseCostController = TextEditingController();
    final TextEditingController expenseNoteController = TextEditingController();
    List<String> categories = [
      "Food and Drinks",
      "Transportation",
      "Education",
      "Housing and Utilities",
      "Entertainment and Social Activities"
    ];
    String _selectedCategory = "Food and Drinks";

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
                            value: _selectedCategory,
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
                              _selectedCategory = newValue!;
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
                          _addExpense(
                            expenseTitleController.text,
                            cost,
                            _selectedCategory,
                            expenseNoteController.text,
                          );
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Add",
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
    final expenseProvider = context.watch<ExpenseProvider>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF60BD8A),
        foregroundColor: Color(0xFFFFFFFF),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person, color: Color(0xFFFFFFFF)),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: const Text(
          "Home",
          style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 30,
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFF31AA68),
      ),
      backgroundColor: const Color(0xFF31AA68),
      body: expenseProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFFFFF)))
          : expenseProvider.expenses.isEmpty
              ? const Center(
                  child: Text(
                    "No expense has been added.",
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 18,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "You're expenses:",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                          height:
                              16), // Adds spacing between the header and the list
                      Expanded(
                        // Ensures the ListView.builder takes up remaining space
                        child: ListView.builder(
                          itemCount: expenseProvider.expenses.length,
                          itemBuilder: (context, index) {
                            final expense = expenseProvider.expenses[index];
                            return GestureDetector(
                              onTap: () {},
                              child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: ExpenseCard(
                                      title: expense["title"],
                                      cost: expense["cost"],
                                      category: expense["category"],
                                      note: expense["note"],
                                      expenseId: expense["id"],
                                      userId: expense[
                                          "createdBy"])), //NOTE: Tinggal nampilin dari firebase ke sini pake cardnya sama signup signinnya gg lagi kayaknya
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
