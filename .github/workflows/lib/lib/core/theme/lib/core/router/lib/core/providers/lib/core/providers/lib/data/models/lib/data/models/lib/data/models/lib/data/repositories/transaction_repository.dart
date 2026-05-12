import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final Box<TransactionModel> _box = Hive.box<TransactionModel>('transactions');
  final _uuid = const Uuid();

  // Get all transactions
  List<TransactionModel> getAllTransactions() {
    return _box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get transactions by type
  List<TransactionModel> getByType(TransactionType type) {
    return _box.values
        .where((t) => t.type == type)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get transactions by month
  List<TransactionModel> getByMonth(int month, int year) {
    return _box.values
        .where((t) => t.date.month == month && t.date.year == year)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get transactions by category
  List<TransactionModel> getByCategory(String categoryId) {
    return _box.values
        .where((t) => t.categoryId == categoryId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Add transaction
  Future<void> addTransaction({
    required String title,
    required double amount,
    required TransactionType type,
    required String categoryId,
    required DateTime date,
    String? note,
    String? imagePath,
    required String paymentMethod,
  }) async {
    final transaction = TransactionModel(
      id: _uuid.v4(),
      title: title,
      amount: amount,
      type: type,
      categoryId: categoryId,
      date: date,
      note: note,
      imagePath: imagePath,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
    );
    await _box.put(transaction.id, transaction);
  }

  // Update transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }

  // Delete transaction
  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  // Get total income for month
  double getTotalIncome(int month, int year) {
    return getByMonth(month, year)
        .where((t) => t.type == TransactionType.income)
        .fold(0, (sum, t) => sum + t.amount);
  }

  // Get total expense for month
  double getTotalExpense(int month, int year) {
    return getByMonth(month, year)
        .where((t) => t.type == TransactionType.expense)
        .fold(0, (sum, t) => sum + t.amount);
  }

  // Get total balance
  double getTotalBalance() {
    double income = _box.values
        .where((t) => t.type == TransactionType.income)
        .fold(0, (sum, t) => sum + t.amount);
    double expense = _box.values
        .where((t) => t.type == TransactionType.expense)
        .fold(0, (sum, t) => sum + t.amount);
    return income - expense;
  }

  // Search transactions
  List<TransactionModel> searchTransactions(String query) {
    return _box.values
        .where((t) =>
            t.title.toLowerCase().contains(query.toLowerCase()) ||
            (t.note?.toLowerCase().contains(query.toLowerCase()) ?? false))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get spending by category for month
  Map<String, double> getSpendingByCategory(int month, int year) {
    final transactions = getByMonth(month, year)
        .where((t) => t.type == TransactionType.expense);
    
    Map<String, double> result = {};
    for (var t in transactions) {
      result[t.categoryId] = (result[t.categoryId] ?? 0) + t.amount;
    }
    return result;
  }

  // Get daily spending for month
  Map<int, double> getDailySpending(int month, int year) {
    final transactions = getByMonth(month, year)
        .where((t) => t.type == TransactionType.expense);
    
    Map<int, double> result = {};
    for (var t in transactions) {
      result[t.date.day] = (result[t.date.day] ?? 0) + t.amount;
    }
    return result;
  }
}

// Provider
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository();
});

// Transactions stream provider
final transactionsProvider = Provider<List<TransactionModel>>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.getAllTransactions();
});

// Monthly stats provider
final monthlyStatsProvider = Provider.family<Map<String, double>, DateTime>((ref, date) {
  final repo = ref.watch(transactionRepositoryProvider);
  return {
    'income': repo.getTotalIncome(date.month, date.year),
    'expense': repo.getTotalExpense(date.month, date.year),
    'balance': repo.getTotalBalance(),
  };
});
