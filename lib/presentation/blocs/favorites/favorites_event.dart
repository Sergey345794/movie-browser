import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class FavoritesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFavoritesRequested extends FavoritesEvent {}

class RemoveFromFavoritesRequested extends FavoritesEvent {
  final String imdbId;

  RemoveFromFavoritesRequested({required this.imdbId});

  @override
  List<Object?> get props => [imdbId];
}

class AddToFavoritesRequested extends FavoritesEvent {
  final Movie movie;

  AddToFavoritesRequested({required this.movie});

  @override
  List<Object?> get props => [movie];
}
