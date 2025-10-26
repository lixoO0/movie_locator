import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/tv_show.dart';

part 'tv_show_model.g.dart';

@JsonSerializable()
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
  
  factory TvShowModel.fromJson(Map<String, dynamic> json) =>
      _$TvShowModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$TvShowModelToJson(this);
  
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
