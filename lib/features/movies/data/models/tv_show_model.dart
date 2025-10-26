import '../../domain/entities/tv_show.dart';

class TvShowModel extends TvShow {
  const TvShowModel({
    required super.id,
    required super.name,
    required super.overview,
    super.posterPath,
    super.backdropPath,
    required super.firstAirDate,
    required super.voteAverage,
    required super.voteCount,
    required super.genreIds,
    required super.originalLanguage,
    required super.originalName,
    required super.popularity,
    required super.originCountry,
  });
  
  factory TvShowModel.fromJson(Map<String, dynamic> json) {
    return TvShowModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      firstAirDate: json['first_air_date'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
      genreIds: (json['genre_ids'] as List<dynamic>?)?.cast<int>() ?? [],
      originalLanguage: json['original_language'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      originCountry: (json['origin_country'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'first_air_date': firstAirDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'genre_ids': genreIds,
      'original_language': originalLanguage,
      'original_name': originalName,
      'popularity': popularity,
      'origin_country': originCountry,
    };
  }
  
  factory TvShowModel.fromEntity(TvShow tvShow) {
    return TvShowModel(
      id: tvShow.id,
      name: tvShow.name,
      overview: tvShow.overview,
      posterPath: tvShow.posterPath,
      backdropPath: tvShow.backdropPath,
      firstAirDate: tvShow.firstAirDate,
      voteAverage: tvShow.voteAverage,
      voteCount: tvShow.voteCount,
      genreIds: tvShow.genreIds,
      originalLanguage: tvShow.originalLanguage,
      originalName: tvShow.originalName,
      popularity: tvShow.popularity,
      originCountry: tvShow.originCountry,
    );
  }
}
