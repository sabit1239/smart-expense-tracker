import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 2)
class CategoryModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String icon;

  @HiveField(3)
  late int color;

  @HiveField(4)
  late bool isIncome;

  @HiveField(5)
  late bool isCustom;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.isIncome,
    this.isCustom = false,
  });
}
