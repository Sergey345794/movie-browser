import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie_details.dart';

abstract class MovieDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsSuccess extends MovieDetailsState {
  final MovieDetails details;
  final bool isFavorite;
  final bool fromCache;

  MovieDetailsSuccess({
    required this.details,
    required this.isFavorite,
    this.fromCache = false,
  });

  @override
  List<Object?> get props => [details, isFavorite, fromCache];
}

class MovieDetailsError extends MovieDetailsState {
  final String message;

  MovieDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
