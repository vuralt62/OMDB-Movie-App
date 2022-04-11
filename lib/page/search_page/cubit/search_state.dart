import 'package:equatable/equatable.dart';

import '../modal.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();

  @override
  List<Object?> get props => [];
}

class SearchLoading extends SearchState {
  const SearchLoading();

  @override
  List<Object?> get props => [];
}

class SearchDone extends SearchState {
  final SearchMovie searchMovie;
  const SearchDone(this.searchMovie);

  @override
  List<Object?> get props => [searchMovie];
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
