import 'package:hive_flutter/hive_flutter.dart';

part 'bookmark_modal.g.dart';

@HiveType(typeId: 1)
class BookMarkedMovie {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? year;

  @HiveField(3)
  String? poster;

  BookMarkedMovie({this.id, this.title, this.year, this.poster});
}