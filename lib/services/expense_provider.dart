import 'package:flutter/material.dart';
import 'package:matespendsapp/services/firebase.dart';

class ExpenseProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  late String userId;
  List<Map<String, dynamic>> expenses = [];
  bool isLoading = true;

  Future<void> loadExpenses(String userId) async {
    try {
      List<Map<String, dynamic>> fetchExpenses =
          await _firebaseService.fetchExpenses();

      expenses = fetchExpenses
          .where((expense) => expense['createdById'] == userId)
          .toList();
      isLoading = false;

      notifyListeners(); // Notify UI to rebuild
    } catch (e) {
      print("Error loading expenses: $e");
    }
  }

  Future<void> addExpense(BuildContext context, String userId, String title,
      int? cost, String category, String? note) async {
    try {
      if (title.isEmpty || cost == null || category.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields')),
        );
        return;
      }

      String username = await _firebaseService.getUsernameById(userId);

      if (note == null || note.isEmpty) {
        note = "-";
      }

      await _firebaseService.addExpense({
        'title': title,
        'cost': cost,
        'category': category,
        'note': note,
        'createdBy': username,
        'createdById': userId,
        'createdAt': DateTime.now().toIso8601String(),
      });

      await loadExpenses(userId); // Refresh the expenses list

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense has been added successfully!')),
      );
    } catch (e) {
      print('Error adding expense: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding expense: $e')),
      );
    }
  }

  Future<void> editExpense(String expenseId, String title, int? cost,
      String category, String? note) async {
    if (title.isEmpty || cost == null || category.isEmpty) {
      throw Exception('Please fill in all required fields');
    }

    await _firebaseService.editExpense(expenseId, {
      'title': title,
      'cost': cost,
      'category': category,
      'note': note,
    });

    loadExpenses(userId);
  }

  void deleteExpense(BuildContext context, String expenseId) async {
    try {
      await FirebaseService().deleteExpense(expenseId);
      loadExpenses(userId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Expense deleted successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting expense: $e")),
      );
    }
  }
}
