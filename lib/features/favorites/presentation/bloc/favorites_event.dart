import 'package:equatable/equatable.dart';
import '../../domain/entities/favorite_movie.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  
  @override
  List<Object> get props => [];
}

class LoadFavoritesEvent extends FavoritesEvent {
  const LoadFavoritesEvent();
}

class AddFavoriteEvent extends FavoritesEvent {
  final FavoriteMovie favorite;
  
  const AddFavoriteEvent(this.favorite);
  
  @override
  List<Object> get props => [favorite];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final int id;
  
  const RemoveFavoriteEvent(this.id);
  
  @override
  List<Object> get props => [id];
}

class CheckFavoriteEvent extends FavoritesEvent {
  final int id;
  
  const CheckFavoriteEvent(this.id);
  
  @override
  List<Object> get props => [id];
}

