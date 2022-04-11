import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/constants/service_info.dart';
import 'package:movie_app/page/detail_page/modal.dart';
import 'package:movie_app/page/search_page/modal.dart';

class WebService {
  Future<SearchMovie> fetchMoviesWithSearch(String search) async {
    SearchMovie searchMovie = SearchMovie();
    final response = await http.get(Uri.parse(serviceUrl + "?apikey=" + apiKey + "&s=" + search));
    if (response.statusCode == 200) {
      searchMovie = SearchMovie.fromJson(jsonDecode(response.body));
    }

    return searchMovie;
  }

  Future<SearchMovie> fetchMoviesWithSearchAndFilter(String search, String query) async {
    SearchMovie searchMovie = SearchMovie();
    final response = await http
        .get(Uri.parse(serviceUrl + "?apikey=" + apiKey + "&s=" + search + query));
    if (response.statusCode == 200) {
      searchMovie = SearchMovie.fromJson(jsonDecode(response.body));
    }

    return searchMovie;
  }

  Future<SearchMovie> nextPageWithSearch(String search, int page) async {
    SearchMovie searchMovie = SearchMovie();
    final response =
        await http.get(Uri.parse(serviceUrl + "?apikey=" + apiKey + "&s=" + search + "&page=" + page.toString()));
    if (response.statusCode == 200) {
      searchMovie = SearchMovie.fromJson(jsonDecode(response.body));
    }

    return searchMovie;
  }

  Future<MovieDetails> getMovieDetail(String imdbID) async {
    MovieDetails movieDetails = MovieDetails();
    final response = await http.get(Uri.parse(serviceUrl + "?apikey=" + apiKey + "&i=" + imdbID + "&plot=full"));
    if (response.statusCode == 200) {
      movieDetails = MovieDetails.fromJson(jsonDecode(response.body));
    }

    return movieDetails;
  }
}
