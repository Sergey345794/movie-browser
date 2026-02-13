import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String imdbId;
  final String title;
  final String year;
  final String posterUrl;
  final String type;

  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.posterUrl,
    required this.type,
  });

  @override
  List<Object?> get props => [imdbId, title, year, posterUrl, type];
}
