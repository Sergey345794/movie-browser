import '../entities/movie.dart';
import '../entities/movie_details.dart';
import '../entities/movie_search_result.dart';

abstract class MovieRepository {
  Future<MovieSearchResult> searchMovies(String query, int page);
  Future<MovieDetails> getMovieDetails(String imdbId);
  Future<MovieDetails?> getCachedDetails(String imdbId);
  Future<List<Movie>> getFavorites();
  Future<void> addToFavorites(Movie movie);
  Future<void> removeFromFavorites(String imdbId);
  Future<bool> isFavorite(String imdbId);
}
