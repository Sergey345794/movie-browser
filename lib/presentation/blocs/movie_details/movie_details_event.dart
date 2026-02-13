import 'package:equatable/equatable.dart';

abstract class MovieDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMovieDetailsRequested extends MovieDetailsEvent {
  final String imdbId;

  LoadMovieDetailsRequested({required this.imdbId});

  @override
  List<Object?> get props => [imdbId];
}

class ToggleFavoriteRequested extends MovieDetailsEvent {}
