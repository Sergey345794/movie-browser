import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class MovieSearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieSearchInitial extends MovieSearchState {}

class MovieSearchLoading extends MovieSearchState {}

class MovieSearchSuccess extends MovieSearchState {
  final List<Movie> movies;
  final int totalResults;
  final int currentPage;
  final bool hasMore;

  MovieSearchSuccess({
    required this.movies,
    required this.totalResults,
    required this.currentPage,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [movies, totalResults, currentPage, hasMore];
}

class MovieSearchLoadingMore extends MovieSearchState {
  final List<Movie> movies;
  final int currentPage;

  MovieSearchLoadingMore({
    required this.movies,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [movies, currentPage];
}

class MovieSearchError extends MovieSearchState {
  final String message;

  MovieSearchError({required this.message});

  @override
  List<Object?> get props => [message];
}
