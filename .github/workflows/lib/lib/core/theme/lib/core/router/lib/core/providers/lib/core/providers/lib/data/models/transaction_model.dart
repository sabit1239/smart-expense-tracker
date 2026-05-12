import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late double amount;

  @HiveField(3)
  late TransactionType type;

  @HiveField(4)
  late String categoryId;

  @HiveField(5)
  late DateTime date;

  @HiveField(6)
  String? note;

  @HiveField(7)
  String? imagePath;

  @HiveField(8)
  late String paymentMethod;

  @HiveField(9)
  late DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.note,
    this.imagePath,
    required this.paymentMethod,
    required this.createdAt,
  });
}
