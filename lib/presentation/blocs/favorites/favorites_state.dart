import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class FavoritesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesSuccess extends FavoritesState {
  final List<Movie> favorites;

  FavoritesSuccess({required this.favorites});

  @override
  List<Object?> get props => [favorites];
}

class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError({required this.message});

  @override
  List<Object?> get props => [message];
}
