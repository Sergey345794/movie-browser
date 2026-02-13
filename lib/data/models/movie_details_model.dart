import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/movie_details.dart';

part 'movie_details_model.g.dart';

@JsonSerializable()
class MovieDetailsModel {
  @JsonKey(name: 'imdbID')
  final String imdbId;

  @JsonKey(name: 'Title')
  final String title;

  @JsonKey(name: 'Year')
  final String year;

  @JsonKey(name: 'Rated')
  final String rated;

  @JsonKey(name: 'Released')
  final String released;

  @JsonKey(name: 'Runtime')
  final String runtime;

  @JsonKey(name: 'Genre')
  final String genre;

  @JsonKey(name: 'Director')
  final String director;

  @JsonKey(name: 'Writer')
  final String writer;

  @JsonKey(name: 'Actors')
  final String actors;

  @JsonKey(name: 'Plot')
  final String plot;

  @JsonKey(name: 'Language')
  final String language;

  @JsonKey(name: 'Country')
  final String country;

  @JsonKey(name: 'Awards')
  final String awards;

  @JsonKey(name: 'Poster')
  final String poster;

  @JsonKey(name: 'imdbRating')
  final String imdbRating;

  @JsonKey(name: 'imdbVotes')
  final String imdbVotes;

  @JsonKey(name: 'Type')
  final String type;

  MovieDetailsModel({
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
    required this.poster,
    required this.imdbRating,
    required this.imdbVotes,
    required this.type,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailsModelToJson(this);

  MovieDetails toEntity() {
    return MovieDetails(
      imdbId: imdbId,
      title: title,
      year: year,
      rated: rated,
      released: released,
      runtime: runtime,
      genre: genre,
      director: director,
      writer: writer,
      actors: actors,
      plot: plot,
      language: language,
      country: country,
      awards: awards,
      posterUrl: poster,
      imdbRating: imdbRating,
      imdbVotes: imdbVotes,
      type: type,
    );
  }
}
