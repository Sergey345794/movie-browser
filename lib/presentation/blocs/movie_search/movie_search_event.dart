import 'package:equatable/equatable.dart';

abstract class MovieSearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchMoviesRequested extends MovieSearchEvent {
  final String query;
  final int page;

  SearchMoviesRequested({
    required this.query,
    this.page = 1,
  });

  @override
  List<Object?> get props => [query, page];
}

class LoadMoreMoviesRequested extends MovieSearchEvent {
  final String query;
  final int page;

  LoadMoreMoviesRequested({
    required this.query,
    required this.page,
  });

  @override
  List<Object?> get props => [query, page];
}

class SearchCleared extends MovieSearchEvent {}
