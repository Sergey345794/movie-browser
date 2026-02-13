import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/errors/failure.dart';
import '../models/movie_details_model.dart';
import '../models/movie_search_response_model.dart';

class MovieRemoteDatasource {
  final ApiClient apiClient;

  MovieRemoteDatasource({required this.apiClient});

  Future<MovieSearchResponseModel> searchMovies(String query, int page) async {
    final response = await apiClient.get(
      ApiEndpoints.search,
      queryParameters: {
        's': query,
        'page': page.toString(),
      },
    );

    final model = MovieSearchResponseModel.fromJson(response.data);

    if (model.response == 'False') {
      // Check for specific error messages
      final data = response.data as Map<String, dynamic>;
      final error = data['Error'] as String?;
      if (error != null) {
        if (error.contains('Too many results')) {
          throw const TooManyResultsFailure();
        }
        if (error.contains('Movie not found')) {
          throw const MovieNotFoundFailure();
        }
      }
      throw const ApiFailure();
    }

    if (model.search == null || model.search!.isEmpty) {
      throw const EmptyResultsFailure();
    }

    return model;
  }

  Future<MovieDetailsModel> getMovieDetails(String imdbId) async {
    final response = await apiClient.get(
      ApiEndpoints.movie,
      queryParameters: {
        'i': imdbId,
        'plot': 'full',
      },
    );

    final data = response.data as Map<String, dynamic>;

    if (data['Response'] == 'False') {
      // Check if the error is "Movie not found!"
      final error = data['Error'] as String?;
      if (error != null && error.contains('Movie not found')) {
        throw const MovieNotFoundFailure();
      }
      throw const ApiFailure();
    }

    return MovieDetailsModel.fromJson(data);
  }
}
