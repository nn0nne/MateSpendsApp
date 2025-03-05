import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;

  Future<List<Map<String, dynamic>>> fetchExpenses(
      {int limit = 10, DocumentSnapshot? lastDoc}) async {
    try {
      Query query = _firestore
          .collection('Expenses')
          .orderBy('createdAt', descending: true);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      QuerySnapshot snapshot = await query.limit(limit).get();
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print('Error fetching expenses: $e');
      return [];
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      await _firestore.collection('Expenses').doc(expenseId).delete();
      print('Expense deleted successfully');
    } catch (e) {
      print('Error deleting expense: $e');
    }
  }

  //
  Future<String> getUsernameById(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc[
            'username']; // Assuming you store username as 'username' field
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addExpense(Map<String, dynamic> expenseData) async {
    try {
      await _firestore.collection('Expenses').add(expenseData);
    } catch (e) {
      print('Error adding playlist: $e');
    }
  }

  Future<void> editExpense(
      String expenseId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore
          .collection('Expenses')
          .doc(expenseId)
          .update(updatedData);
      print('Expense updated successfully');
    } catch (e) {
      print('Error updating expense: $e');
    }
  }
}
