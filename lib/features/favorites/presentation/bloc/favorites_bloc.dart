import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/remove_favorite.dart';
import '../../domain/usecases/check_is_favorite.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavorites;
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;
  final CheckIsFavorite checkIsFavorite;
  
  FavoritesBloc({
    required this.getFavorites,
    required this.addFavorite,
    required this.removeFavorite,
    required this.checkIsFavorite,
  }) : super(const FavoritesInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<CheckFavoriteEvent>(_onCheckFavorite);
  }
  
  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(const FavoritesLoading());
    
    final result = await getFavorites();
    
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }
  
  Future<void> _onAddFavorite(
    AddFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await addFavorite(AddFavoriteParams(favorite: event.favorite));
    
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) {
        // Reload favorites after adding
        add(const LoadFavoritesEvent());
      },
    );
  }
  
  Future<void> _onRemoveFavorite(
    RemoveFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await removeFavorite(RemoveFavoriteParams(id: event.id));
    
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) {
        // Reload favorites after removing
        add(const LoadFavoritesEvent());
      },
    );
  }
  
  Future<void> _onCheckFavorite(
    CheckFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await checkIsFavorite(CheckIsFavoriteParams(id: event.id));
    
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (isFavorite) => emit(FavoriteStatusChecked(event.id, isFavorite)),
    );
  }
}

