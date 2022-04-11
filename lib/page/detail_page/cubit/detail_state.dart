import 'package:equatable/equatable.dart';
import 'package:movie_app/page/detail_page/modal.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object?> get props => [];
}

class DetailInitial extends DetailState {
  const DetailInitial();

  @override
  List<Object?> get props => [];
}

class DetailLoading extends DetailState {
  const DetailLoading();

  @override
  List<Object?> get props => [];
}

class DetailDone extends DetailState {
  final MovieDetails movieDetails;
  const DetailDone(this.movieDetails);

  @override
  List<Object?> get props => [movieDetails];
}

class DetailError extends DetailState {
  final String message;
  const DetailError(this.message);

  @override
  List<Object?> get props => [message];
}
