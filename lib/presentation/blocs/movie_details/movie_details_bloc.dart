import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/errors/failure.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/repositories/movie_repository.dart';
import 'movie_details_event.dart';
import 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final MovieRepository repository;

  MovieDetailsBloc({required this.repository}) : super(MovieDetailsInitial()) {
    on<LoadMovieDetailsRequested>(_onLoadMovieDetailsRequested);
    on<ToggleFavoriteRequested>(_onToggleFavoriteRequested);
  }

  Future<void> _onLoadMovieDetailsRequested(
    LoadMovieDetailsRequested event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(MovieDetailsLoading());

    try {
      final details = await repository.getMovieDetails(event.imdbId);
      final isFavorite = await repository.isFavorite(event.imdbId);

      emit(MovieDetailsSuccess(
        details: details,
        isFavorite: isFavorite,
        fromCache: false,
      ));
    } catch (failure) {
      final cached = await repository.getCachedDetails(event.imdbId);
      if (cached != null) {
        final isFavorite = await repository.isFavorite(event.imdbId);
        emit(MovieDetailsSuccess(
          details: cached,
          isFavorite: isFavorite,
          fromCache: true,
        ));
      } else {
        if (failure is NetworkFailure) {
          emit(MovieDetailsError(message: 'network_error'));
        } else if (failure is MovieNotFoundFailure) {
          emit(MovieDetailsError(message: 'movie_not_found'));
        } else if (failure is ApiFailure) {
          emit(MovieDetailsError(message: 'api_error'));
        } else {
          emit(MovieDetailsError(message: 'error_occurred'));
        }
      }
    }
  }

  Future<void> _onToggleFavoriteRequested(
    ToggleFavoriteRequested event,
    Emitter<MovieDetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MovieDetailsSuccess) return;

    final details = currentState.details;
    final isFavorite = currentState.isFavorite;

    try {
      if (isFavorite) {
        await repository.removeFromFavorites(details.imdbId);
      } else {
        final movie = Movie(
          imdbId: details.imdbId,
          title: details.title,
          year: details.year,
          posterUrl: details.posterUrl,
          type: details.type,
        );
        await repository.addToFavorites(movie);
      }

      emit(MovieDetailsSuccess(
        details: details,
        isFavorite: !isFavorite,
        fromCache: currentState.fromCache,
      ));
    } catch (_) {}
  }
}
