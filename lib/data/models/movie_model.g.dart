// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => MovieModel(
      imdbId: json['imdbID'] as String,
      title: json['Title'] as String,
      year: json['Year'] as String,
      poster: json['Poster'] as String,
      type: json['Type'] as String,
    );

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      'imdbID': instance.imdbId,
      'Title': instance.title,
      'Year': instance.year,
      'Poster': instance.poster,
      'Type': instance.type,
    };
