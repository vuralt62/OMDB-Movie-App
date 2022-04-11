class SearchMovie {
  List<Search>? search;
  String? totalResults;
  String? response;

  SearchMovie({this.search, this.totalResults, this.response});

  SearchMovie.fromJson(Map<String, dynamic> json) {
    if (json['Search'] != null) {
      search = <Search>[];
      json['Search'].forEach((v) {
        search!.add(Search.fromJson(v));
      });
    }
    totalResults = json['totalResults'];
    response = json['Response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (search != null) {
      data['Search'] = search!.map((v) => v.toJson()).toList();
    }
    data['totalResults'] = totalResults;
    data['Response'] = response;
    return data;
  }
}

class Search {
  late String title;
  late String year;
  late String imdbID;
  late String type;
  late String poster;

  Search({required this.title, required this.year, required this.imdbID, required this.type, required this.poster});

  Search.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    year = json['Year'];
    imdbID = json['imdbID'];
    type = json['Type'];
    poster = json['Poster'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Title'] = title;
    data['Year'] = year;
    data['imdbID'] = imdbID;
    data['Type'] = type;
    data['Poster'] = poster;
    return data;
  }
}
