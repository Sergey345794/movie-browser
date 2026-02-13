import 'package:equatable/equatable.dart';

class MovieDetails extends Equatable {
  final String imdbId;
  final String title;
  final String year;
  final String rated;
  final String released;
  final String runtime;
  final String genre;
  final String director;
  final String writer;
  final String actors;
  final String plot;
  final String language;
  final String country;
  final String awards;
  final String posterUrl;
  final String imdbRating;
  final String imdbVotes;
  final String type;

  const MovieDetails({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.rated,
    required this.released,
    required this.runtime,
    required this.genre,
    required this.director,
    required this.writer,
    required this.actors,
    required this.plot,
    required this.language,
    required this.country,
    required this.awards,
    required this.posterUrl,
    required this.imdbRating,
    required this.imdbVotes,
    required this.type,
  });

  @override
  List<Object?> get props => [
        imdbId,
        title,
        year,
        rated,
        released,
        runtime,
        genre,
        director,
        writer,
        actors,
        plot,
        language,
        country,
        awards,
        posterUrl,
        imdbRating,
        imdbVotes,
        type,
      ];
}
