import 'package:equatable/equatable.dart';

class TvShow extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String firstAirDate;
  final double voteAverage;
  final int voteCount;
  final List<int> genreIds;
  final String originalLanguage;
  final String originalName;
  final double popularity;
  final List<String> originCountry;
  
  const TvShow({
    required this.id,
    required this.name,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
    required this.originalLanguage,
    required this.originalName,
    required this.popularity,
    required this.originCountry,
  });
  
  @override
  List<Object?> get props => [
    id,
    name,
    overview,
    posterPath,
    backdropPath,
    firstAirDate,
    voteAverage,
    voteCount,
    genreIds,
    originalLanguage,
    originalName,
    popularity,
    originCountry,
  ];
}
