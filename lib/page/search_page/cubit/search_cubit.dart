import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/services/web_service.dart';
import 'package:movie_app/constants/extentions_import.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final WebService _webService;
  SearchCubit(this._webService) : super(const SearchInitial());

  int? searchYear;
  String? searchType;
  int year = DateTime.now().year;
  String type = "movie";
  bool isFilter = false;
  bool firstSearch = false;
  bool checkboxFirst = false;
  bool checkboxSecond = false;

  Future<void> getMovies(String search) async {
    try {
      emit(const SearchLoading());
      final searchMovie = await _webService.fetchMoviesWithSearch(search);
      if (searchMovie.response?.toLowerCase() == "false") {
        throw Exception("Wrong query");
      }
      isFilter = false;
      firstSearch = true;
      emit(SearchDone(searchMovie));
    } on Exception catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> getMoviesWithFilter(String search) async {
    try {
      emit(const SearchLoading());
      String query = "";
      if (checkboxFirst) {
        query = query + "&y=$year";
      }
      if (checkboxSecond) {
        query = query + "&type=$type";
      }
      final searchMovie = await _webService.fetchMoviesWithSearchAndFilter(search, query);
      if (searchMovie.response?.toLowerCase() == "false") {
        throw Exception("Wrong query");
      }
      searchYear = year;
      searchType = type;
      isFilter = true;
      emit(SearchDone(searchMovie));
    } on Exception catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> nextPage(String search, int page) async {
    try {
      emit(const SearchLoading());
      final searchMovie = await _webService.nextPageWithSearch(search, page);
      if (searchMovie.response?.toLowerCase() == "false") {
        throw Exception("Wrong query");
      }
      emit(SearchDone(searchMovie));
    } on Exception catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void changeYear(int year) {
    this.year = year;
  }

  void changeType(String type) {
    this.type = type;
  }

  void changeFirstCb(bool value) {
    checkboxFirst = value;
  }

  void changeSecondCb(bool value) {
    checkboxSecond = value;
  }

  String getFilterInfo() {
    String info = "";
    if (checkboxFirst) {
      info = info + year.toString();
    }
    if (checkboxSecond) {
      if (info != "") {
        info = info + " ";
      }
      info = info + type.capitalize();
    }
    return info;
  }
}
