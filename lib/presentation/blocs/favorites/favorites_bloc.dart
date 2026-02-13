import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/movie_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final MovieRepository repository;

  FavoritesBloc({required this.repository}) : super(FavoritesInitial()) {
    on<LoadFavoritesRequested>(_onLoadFavoritesRequested);
    on<RemoveFromFavoritesRequested>(_onRemoveFromFavoritesRequested);
    on<AddToFavoritesRequested>(_onAddToFavoritesRequested);
  }

  Future<void> _onLoadFavoritesRequested(
    LoadFavoritesRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());

    try {
      final favorites = await repository.getFavorites();
      emit(FavoritesSuccess(favorites: favorites));
    } catch (_) {
      emit(FavoritesError(message: 'error_occurred'));
    }
  }

  Future<void> _onRemoveFromFavoritesRequested(
    RemoveFromFavoritesRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FavoritesSuccess) return;

    try {
      await repository.removeFromFavorites(event.imdbId);
      final updatedFavorites = currentState.favorites
          .where((movie) => movie.imdbId != event.imdbId)
          .toList();
      emit(FavoritesSuccess(favorites: updatedFavorites));
    } catch (_) {
      emit(FavoritesError(message: 'error_occurred'));
    }
  }

  Future<void> _onAddToFavoritesRequested(
    AddToFavoritesRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FavoritesSuccess) return;

    try {
      await repository.addToFavorites(event.movie);
      final updatedFavorites = [...currentState.favorites, event.movie];
      emit(FavoritesSuccess(favorites: updatedFavorites));
    } catch (_) {
      emit(FavoritesError(message: 'error_occurred'));
    }
  }
}
