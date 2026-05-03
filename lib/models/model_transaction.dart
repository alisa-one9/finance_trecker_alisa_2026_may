import 'package:hive/hive.dart';

part 'model_transaction.g.dart';

@HiveType(typeId: 0)
class Model_Trancaction extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String type;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String category;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  String comment;
  Model_Trancaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    required this.comment,
  });
}
