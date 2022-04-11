import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/constants/service_info.dart';
import 'package:movie_app/page/bookmark_page/bookmark_modal.dart';
import 'package:movie_app/page/detail_page/cubit/detail_state.dart';
import 'package:movie_app/page/detail_page/modal.dart';
import 'package:movie_app/services/database_service.dart';
import 'package:movie_app/services/web_service.dart';

class DetailCubit extends Cubit<DetailState> {
  final WebService _webService;
  DetailCubit(this._webService) : super(const DetailInitial()) {
    changeState(const DetailInitial());
  }

  final ServiceManager<BookMarkedMovie> _databaseManager = DatabaseManager(database);
  MovieDetails movieDetails = MovieDetails();
  bool isBookmarked = false;

  Future<void> getMovieDetials(String imdbID) async {
    _databaseManager.init();
    emit(const DetailLoading());
    try {
      movieDetails = await _webService.getMovieDetail(imdbID);
      if (movieDetails.response?.toLowerCase() == "false") {
        throw Exception("Wrong query");
      }
      isBookmarked = initIsbookmark(imdbID);
      emit(DetailDone(movieDetails));
    } on Exception catch (e) {
      emit(DetailError(e.toString()));
    }
  }

  bool initIsbookmark(String imdbID) {
    return _databaseManager.isExist(imdbID);
  }

  void changeState(DetailState state) {
    emit(state);
  }

  Future<void> clickBookMark(BookMarkedMovie movie) async {
    emit(const DetailLoading());
    try {
      if (initIsbookmark(movie.id ?? "")) {
        await _databaseManager.removeItem(movie.id ?? "");
        isBookmarked = false;
      } else {
        await _databaseManager
            .putItem(BookMarkedMovie(id: movie.id, title: movie.title, year: movie.year, poster: movie.poster));
        isBookmarked = true;
      }
      emit(DetailDone(movieDetails));
    } on Exception catch (e) {
      emit(DetailError(e.toString()));
    }
  }
}
