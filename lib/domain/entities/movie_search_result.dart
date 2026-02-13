import 'package:equatable/equatable.dart';
import 'movie.dart';

class MovieSearchResult extends Equatable {
  final List<Movie> movies;
  final int totalResults;

  const MovieSearchResult({
    required this.movies,
    required this.totalResults,
  });

  @override
  List<Object?> get props => [movies, totalResults];
}
