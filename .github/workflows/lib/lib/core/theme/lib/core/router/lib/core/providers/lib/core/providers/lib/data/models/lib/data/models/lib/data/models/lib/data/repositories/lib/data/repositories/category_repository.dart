import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final Box<CategoryModel> _box = Hive.box<CategoryModel>('categories');
  final _uuid = const Uuid();

  // Initialize default categories
  Future<void> initDefaultCategories() async {
    if (_box.isNotEmpty) return;

    final defaultCategories = [
      // Expense Categories
      CategoryModel(
        id: 'food',
        name: 'Food & Dining',
        icon: 'restaurant',
        color: Colors.orange.value,
        isIncome: false,
      ),
      CategoryModel(
        id: 'transport',
        name: 'Transport',
        icon: 'directions_car',
        color: Colors.blue.value,
        isIncome: false,
      ),
      CategoryModel(
        id: 'shopping',
        name: 'Shopping',
        icon: 'shopping_bag',
        color: Colors.pink.value,
        isIncome: false,
      ),
      CategoryModel(
        id: 'health',
        name: 'Health',
        icon: 'favorite',
        color: Colors.red.value,
        isIncome: false,
      ),
      CategoryModel(
        id: 'entertainment',
        name: 'Entertainment',
        icon: 'movie',
        color: Colors.purple.value,
        isIncome: false,
      ),
      CategoryModel(
        id: 'education',
        name: 'Education',
        icon: 'school',
        color: Colors.indigo.value,
        isIncome: false,
      ),
      CategoryModel(
        id: 'bills',
        name: 'Bills & Utilities',
        icon: 'receipt',
        color: Colors.teal.value,
        isIncome: false,
      ),
      CategoryModel(
        id: 'groceries',
        name: 'Groceries',
        icon: 'local_grocery_store',
        color: Colors.green.value,
        isIncome: false,
      ),
      CategoryModel(
        id: 'travel',
        name: 'Travel',
        icon: 'flight',
        color: Colors.cyan.value,
        isIncome: false,
      ),
      CategoryModel(
        id: 'other_expense',
        name: 'Other',
        icon: 'more_horiz',
        color: Colors.grey.value,
        isIncome: false,
      ),
      // Income Categories
      CategoryModel(
        id: 'salary',
        name: 'Salary',
        icon: 'account_balance_wallet',
        color: Colors.green.value,
        isIncome: true,
      ),
      CategoryModel(
        id: 'freelance',
        name: 'Freelance',
        icon: 'laptop',
        color: Colors.blue.value,
        isIncome: true,
      ),
      CategoryModel(
        id: 'investment',
        name: 'Investment',
        icon: 'trending_up',
        color: Colors.amber.value,
        isIncome: true,
      ),
      CategoryModel(
        id: 'gift',
        name: 'Gift',
        icon: 'card_giftcard',
        color: Colors.pink.value,
        isIncome: true,
      ),
      CategoryModel(
        id: 'other_income',
        name: 'Other Income',
        icon: 'attach_money',
        color: Colors.teal.value,
        isIncome: true,
      ),
    ];

    for (var category in defaultCategories) {
      await _box.put(category.id, category);
    }
  }

  // Get all categories
  List<CategoryModel> getAllCategories() {
    return _box.values.toList();
  }

  // Get expense categories
  List<CategoryModel> getExpenseCategories() {
    return _box.values.where((c) => !c.isIncome).toList();
  }

  // Get income categories
  List<CategoryModel> getIncomeCategories() {
    return _box.values.where((c) => c.isIncome).toList();
  }

  // Get category by id
  CategoryModel? getCategoryById(String id) {
    return _box.get(id);
  }

  // Add custom category
  Future<void> addCategory({
    required String name,
    required String icon,
    required int color,
    required bool isIncome,
  }) async {
    final category = CategoryModel(
      id: _uuid.v4(),
      name: name,
      icon: icon,
      color: color,
      isIncome: isIncome,
      isCustom: true,
    );
    await _box.put(category.id, category);
  }

  // Delete category
  Future<void> deleteCategory(String id) async {
    await _box.delete(id);
  }
}

// Providers
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

final expenseCategoriesProvider = Provider<List<CategoryModel>>((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.getExpenseCategories();
});

final incomeCategoriesProvider = Provider<List<CategoryModel>>((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.getIncomeCategories();
});
