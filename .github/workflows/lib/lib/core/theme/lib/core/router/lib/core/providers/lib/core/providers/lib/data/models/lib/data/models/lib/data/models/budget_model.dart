import 'package:hive/hive.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 3)
class BudgetModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String categoryId;

  @HiveField(2)
  late double limitAmount;

  @HiveField(3)
  late double spentAmount;

  @HiveField(4)
  late int month;

  @HiveField(5)
  late int year;

  @HiveField(6)
  late DateTime createdAt;

  BudgetModel({
    required this.id,
    required this.categoryId,
    required this.limitAmount,
    this.spentAmount = 0,
    required this.month,
    required this.year,
    required this.createdAt,
  });

  // Budget usage percentage
  double get usagePercent {
    if (limitAmount == 0) return 0;
    return (spentAmount / limitAmount).clamp(0, 1);
  }

  // Remaining amount
  double get remaining => limitAmount - spentAmount;

  // Is over budget
  bool get isOverBudget => spentAmount > limitAmount;
}
