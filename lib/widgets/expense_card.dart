import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matespendsapp/pages/expense_view.dart';
import 'package:matespendsapp/services/expense_provider.dart';
import 'package:provider/provider.dart';

class ExpenseCard extends StatelessWidget {
  final VoidCallback onDelete;
  final String title;
  final int cost;
  final String category;
  final String note;
  final String expenseId;
  final String userId;

  const ExpenseCard({
    super.key,
    required this.onDelete,
    required this.title,
    required this.cost,
    required this.category,
    required this.note,
    required this.expenseId,
    required this.userId,
  });

  void _deleteExpense(BuildContext context, String expenseId) {
    Provider.of<ExpenseProvider>(context, listen: false)
        .deleteExpense(context, expenseId);
  }

  void _showDeleteExpensionDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Color(0xFF60BD8A),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Are you sure you want to delete this expense?",
                    style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () => _deleteExpense(context, expenseId),
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###");

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Color(0x00000000),
          context: context,
          isScrollControlled: true, // Makes it full height if needed
          builder: (context) => ExpenseView(
            title: title,
            cost: cost,
            category: category,
            note: note,
            expenseId: expenseId,
            userId: userId,
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.only(left: 16),
        //height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF60BD8A),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          spacing: 16,
          children: [
            IconButton(
                onPressed: () => _showDeleteExpensionDialog(context),
                //onPressed: () async {
                //  try {
                //    await FirebaseService().deleteExpense(expenseId);
                //    onDelete();
                //    ScaffoldMessenger.of(context).showSnackBar(
                //      const SnackBar(
                //          content: Text("Expense deleted successfully")),
                //    );
                //  } catch (e) {
                //    ScaffoldMessenger.of(context).showSnackBar(
                //      SnackBar(content: Text("Error deleting expense: $e")),
                //    );
                //  }
                //},
                icon: Icon(
                  Icons.delete,
                  color: Color(0xFFFFFFFF),
                )),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEEEEEE),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rp.${formatter.format(cost)}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFEEEEEE),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFEEEEEE),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            note.isNotEmpty
                ? Icon(
                    Icons.info,
                    color: Color(0xFFFFFFFF),
                  )
                : SizedBox.shrink(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
