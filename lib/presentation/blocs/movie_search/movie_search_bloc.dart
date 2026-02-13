import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/errors/failure.dart';
import '../../../domain/repositories/movie_repository.dart';
import 'movie_search_event.dart';
import 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final MovieRepository repository;

  MovieSearchBloc({required this.repository}) : super(MovieSearchInitial()) {
    on<SearchMoviesRequested>(_onSearchMoviesRequested);
    on<LoadMoreMoviesRequested>(_onLoadMoreMoviesRequested);
    on<SearchCleared>(_onSearchCleared);
  }

  Future<void> _onSearchMoviesRequested(
    SearchMoviesRequested event,
    Emitter<MovieSearchState> emit,
  ) async {
    emit(MovieSearchLoading());

    try {
      final result = await repository.searchMovies(event.query, event.page);

      // Filter out movies with invalid IMDb IDs
      final imdbIdPattern = RegExp(r'^tt\d{7,}$');
      final validMovies = result.movies.where((movie) {
        return movie.imdbId.isNotEmpty &&
            movie.imdbId != 'N/A' &&
            imdbIdPattern.hasMatch(movie.imdbId);
      }).toList();

      final hasMore = validMovies.length < result.totalResults;

      emit(MovieSearchSuccess(
        movies: validMovies,
        totalResults: result.totalResults,
        currentPage: event.page,
        hasMore: hasMore,
      ));
    } on NetworkFailure catch (_) {
      emit(MovieSearchError(message: 'network_error'));
    } on MovieNotFoundFailure catch (_) {
      emit(MovieSearchError(message: 'movie_not_found'));
    } on ApiFailure catch (_) {
      emit(MovieSearchError(message: 'api_error'));
    } on EmptyResultsFailure catch (_) {
      emit(MovieSearchError(message: 'no_results_found'));
    } on TooManyResultsFailure catch (_) {
      emit(MovieSearchError(message: 'too_many_results'));
    } catch (_) {
      emit(MovieSearchError(message: 'error_occurred'));
    }
  }

  Future<void> _onLoadMoreMoviesRequested(
    LoadMoreMoviesRequested event,
    Emitter<MovieSearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MovieSearchSuccess) return;

    emit(MovieSearchLoadingMore(
      movies: currentState.movies,
      currentPage: currentState.currentPage,
    ));

    try {
      final result = await repository.searchMovies(event.query, event.page);

      // Filter out movies with invalid IMDb IDs
      final imdbIdPattern = RegExp(r'^tt\d{7,}$');
      final validNewMovies = result.movies.where((movie) {
        return movie.imdbId.isNotEmpty &&
            movie.imdbId != 'N/A' &&
            imdbIdPattern.hasMatch(movie.imdbId);
      }).toList();

      final allMovies = [...currentState.movies, ...validNewMovies];
      final hasMore = allMovies.length < result.totalResults;

      emit(MovieSearchSuccess(
        movies: allMovies,
        totalResults: result.totalResults,
        currentPage: event.page,
        hasMore: hasMore,
      ));
    } on NetworkFailure catch (_) {
      emit(MovieSearchError(message: 'network_error'));
    } on MovieNotFoundFailure catch (_) {
      emit(MovieSearchError(message: 'movie_not_found'));
    } on ApiFailure catch (_) {
      emit(MovieSearchError(message: 'api_error'));
    } on EmptyResultsFailure catch (_) {
      emit(MovieSearchError(message: 'no_results_found'));
    } on TooManyResultsFailure catch (_) {
      emit(MovieSearchError(message: 'too_many_results'));
    } catch (_) {
      emit(MovieSearchError(message: 'error_occurred'));
    }
  }

  void _onSearchCleared(
    SearchCleared event,
    Emitter<MovieSearchState> emit,
  ) {
    emit(MovieSearchInitial());
  }
}
