import 'package:json_annotation/json_annotation.dart';
import 'movie_model.dart';
import '../../domain/entities/movie_search_result.dart';

part 'movie_search_response_model.g.dart';

@JsonSerializable()
class MovieSearchResponseModel {
  @JsonKey(name: 'Search')
  final List<MovieModel>? search;

  @JsonKey(name: 'totalResults')
  final String? totalResults;

  @JsonKey(name: 'Response')
  final String response;

  MovieSearchResponseModel({
    this.search,
    this.totalResults,
    required this.response,
  });

  factory MovieSearchResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MovieSearchResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieSearchResponseModelToJson(this);

  MovieSearchResult toEntity() {
    return MovieSearchResult(
      movies: search?.map((m) => m.toEntity()).toList() ?? [],
      totalResults: int.tryParse(totalResults ?? '0') ?? 0,
    );
  }
}
