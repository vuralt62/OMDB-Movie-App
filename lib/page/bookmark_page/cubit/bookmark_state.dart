part of 'bookmark_cubit.dart';

abstract class BookmarkState extends Equatable {
  const BookmarkState();

  @override
  List<Object?> get props => [];
}

class BookmarkInitial extends BookmarkState {
  const BookmarkInitial();
}

class BookmarkLoading extends BookmarkState {
  const BookmarkLoading();

  @override
  List<Object?> get props => [];
}

class BookmarkDone extends BookmarkState {
  final List<BookMarkedMovie> bookmarkedList;
  const BookmarkDone(this.bookmarkedList);

  @override
  List<Object?> get props => [bookmarkedList];
}

class BookmarkError extends BookmarkState {
  final String message;
  const BookmarkError(this.message);

  @override
  List<Object?> get props => [message];
}
