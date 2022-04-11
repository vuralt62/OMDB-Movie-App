import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:movie_app/page/bookmark_page/cubit/bookmark_cubit.dart';
import 'package:movie_app/page/detail_page/cubit/detail_cubit.dart';
import 'package:movie_app/page/detail_page/cubit/detail_state.dart';
import 'package:movie_app/page/search_page/cubit/search_cubit.dart';
import 'package:movie_app/page/search_page/search_page_view.dart';
import 'package:movie_app/services/web_service.dart';
import 'constants/service_info.dart';
import 'page/bookmark_page/bookmark_modal.dart';
import 'services/database_service.dart';

Future<void> main() async {
  await Hive.initFlutter();
  final ServiceManager<BookMarkedMovie> _databaseManager = DatabaseManager(database);
  await _databaseManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchCubit>(create: (BuildContext context) => SearchCubit(WebService())),
        BlocProvider<DetailCubit>(
            create: (BuildContext context) => DetailCubit(WebService())..changeState(const DetailInitial())),
        BlocProvider<BookmarkCubit>(create: (BuildContext context) => BookmarkCubit()..getAll())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'OMDB App',
          theme: ThemeData(
              appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
              scaffoldBackgroundColor: Colors.black,
              colorScheme: const ColorScheme.dark(),
              hintColor: Colors.white54,
              iconTheme: const IconThemeData(color: Colors.white),
              textTheme: const TextTheme(
                  headline1: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                  ),
                  headline3: TextStyle(color: Colors.white, fontSize: 18),
                  caption: TextStyle(color: Colors.white54))),
          home: const SearchPage()),
    );
  }
}
