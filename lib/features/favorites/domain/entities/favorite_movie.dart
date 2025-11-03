import 'package:equatable/equatable.dart';

class FavoriteMovie extends Equatable {
  final int id;
  final String title;
  final String overview;
  final double voteAverage;
  final String? posterPath;
  final String type; // 'movie' or 'tv_show'
  final DateTime addedAt;
  
  const FavoriteMovie({
    required this.id,
    required this.title,
    required this.overview,
    required this.voteAverage,
    this.posterPath,
    required this.type,
    required this.addedAt,
  });
  
  @override
  List<Object?> get props => [id, title, overview, voteAverage, posterPath, type, addedAt];
}

