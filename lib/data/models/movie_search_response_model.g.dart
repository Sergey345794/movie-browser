// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_search_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieSearchResponseModel _$MovieSearchResponseModelFromJson(
        Map<String, dynamic> json) =>
    MovieSearchResponseModel(
      search: (json['Search'] as List<dynamic>?)
          ?.map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalResults: json['totalResults'] as String?,
      response: json['Response'] as String,
    );

Map<String, dynamic> _$MovieSearchResponseModelToJson(
        MovieSearchResponseModel instance) =>
    <String, dynamic>{
      'Search': instance.search,
      'totalResults': instance.totalResults,
      'Response': instance.response,
    };
