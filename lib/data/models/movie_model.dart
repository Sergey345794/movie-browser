import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/movie.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel {
  @JsonKey(name: 'imdbID')
  final String imdbId;

  @JsonKey(name: 'Title')
  final String title;

  @JsonKey(name: 'Year')
  final String year;

  @JsonKey(name: 'Poster')
  final String poster;

  @JsonKey(name: 'Type')
  final String type;

  MovieModel({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.poster,
    required this.type,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  Movie toEntity() {
    return Movie(
      imdbId: imdbId,
      title: title,
      year: year,
      posterUrl: poster,
      type: type,
    );
  }

  factory MovieModel.fromEntity(Movie movie) {
    return MovieModel(
      imdbId: movie.imdbId,
      title: movie.title,
      year: movie.year,
      poster: movie.posterUrl,
      type: movie.type,
    );
  }
}
