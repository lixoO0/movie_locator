import 'package:equatable/equatable.dart';
import '../../domain/entities/favorite_movie.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
  
  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final List<FavoriteMovie> favorites;
  
  const FavoritesLoaded(this.favorites);
  
  @override
  List<Object?> get props => [favorites];
}

class FavoritesError extends FavoritesState {
  final String message;
  
  const FavoritesError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class FavoriteStatusChecked extends FavoritesState {
  final int id;
  final bool isFavorite;
  
  const FavoriteStatusChecked(this.id, this.isFavorite);
  
  @override
  List<Object?> get props => [id, isFavorite];
}

