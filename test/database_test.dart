import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app/constants/service_info.dart';
import 'package:movie_app/page/bookmark_page/bookmark_modal.dart';
import 'package:movie_app/services/database_service.dart';

Future<void> main() async {
  test('Databese-Test', () async {
    /*Hive.registerAdapter(BookMarkedMovieAdapter());
    Box<BookMarkedMovie>? box;
    if (false) {
      box = await Hive.openBox<BookMarkedMovie>("bookmarked-movie");
    } else {
      
    }
    /*for (var i = 0; i < 5; i++) {
      final movie = BookMarkedMovie(id: "id$i", name: "nametest", year: "yeartest", poster: "postertest");
      box!.add(movie);
    }*/
    for (BookMarkedMovie item in box!.values) {
      print(item.id);
    }*/
    await Hive.initFlutter();
    ServiceManager<BookMarkedMovie> databaseManager = DatabaseManager(database);
    await databaseManager.init();
    List<BookMarkedMovie>? list = databaseManager.getAllItems();
    if (list != null) {
      for (var i = 0; i < list.length; i++) {
        // ignore: avoid_print
        print(list[i].id! + " " + list[i].title!);
      }
    }
  });
}

/*
box yoksa
isOpen = false,
isNotEmpty = false,
isEmpty = true

varsa
isopen = true
isnotempty = true
isempty = false

*/


