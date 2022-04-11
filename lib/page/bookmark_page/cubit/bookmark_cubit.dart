import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app/constants/service_info.dart';
import 'package:movie_app/page/bookmark_page/bookmark_modal.dart';
import 'package:movie_app/services/database_service.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit() : super(const BookmarkInitial());

  final ServiceManager<BookMarkedMovie> _databaseManager = DatabaseManager(database);

  Future<void> getAll() async {
    emit(const BookmarkLoading());
    try {
      await _databaseManager.init();
      List<BookMarkedMovie>? bookmarkedList = _databaseManager.getAllItems();
      emit(BookmarkDone(bookmarkedList ?? []));
    } on Exception catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }
}
