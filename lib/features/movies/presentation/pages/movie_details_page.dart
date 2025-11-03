import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../bloc/movies_bloc.dart';
import '../bloc/movies_event.dart';
import '../bloc/movies_state.dart';
import '../../domain/entities/movie.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom;
import '../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../../favorites/presentation/bloc/favorites_event.dart';
import '../../../favorites/presentation/bloc/favorites_state.dart';
import '../../../favorites/domain/entities/favorite_movie.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class MovieDetailsPage extends StatefulWidget {
  final int movieId;

  const MovieDetailsPage({
    super.key,
    required this.movieId,
  });

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  bool _isFavorite = false;
  
  @override
  void initState() {
    super.initState();
    context.read<MoviesBloc>().add(GetMovieDetailsEvent(movieId: widget.movieId));
    context.read<FavoritesBloc>().add(CheckFavoriteEvent(widget.movieId));
  }
  
  void _toggleFavorite(Movie movie) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please login to add favorites'),
          action: SnackBarAction(
            label: 'Login',
            onPressed: () => context.go('/login'),
          ),
        ),
      );
      return;
    }
    
    if (_isFavorite) {
      context.read<FavoritesBloc>().add(RemoveFavoriteEvent(movie.id));
    } else {
      final favorite = FavoriteMovie(
        id: movie.id,
        title: movie.title,
        overview: movie.overview,
        voteAverage: movie.voteAverage,
        posterPath: movie.posterPath,
        type: 'movie',
        addedAt: DateTime.now(),
      );
      context.read<FavoritesBloc>().add(AddFavoriteEvent(favorite));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FavoritesBloc, FavoritesState>(
          listener: (context, state) {
            if (state is FavoriteStatusChecked) {
              setState(() {
                _isFavorite = state.isFavorite;
              });
            } else if (state is FavoritesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<MoviesBloc, MoviesState>(
          builder: (context, state) {
          if (state is MovieDetailsLoading) {
            return const LoadingWidget();
          } else if (state is MovieDetailsLoaded) {
            return _buildMovieDetails(state.movie);
          } else if (state is MovieDetailsError) {
            return custom.CustomErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<MoviesBloc>().add(GetMovieDetailsEvent(movieId: widget.movieId));
              },
            );
          }
          return const Center(
            child: Text('No movie details available'),
          );
        },
        ),
      ),
    );
  }

  Widget _buildMovieDetails(Movie movie) {
    return CustomScrollView(
      slivers: [
        // App Bar with backdrop image
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (movie.backdropPath != null)
                  CachedNetworkImage(
                    imageUrl: '${AppConstants.tmdbImageBaseUrl}/${AppConstants.imageSizeLarge}${movie.backdropPath}',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.movie,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
          actions: [
            BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, favoritesState) {
                if (favoritesState is FavoriteStatusChecked && favoritesState.id == movie.id) {
                  _isFavorite = favoritesState.isFavorite;
                }
                return IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : null,
                  ),
                  tooltip: _isFavorite ? 'Remove from favorites' : 'Add to favorites',
                  onPressed: () => _toggleFavorite(movie),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Share',
              onPressed: () {
                // TODO: Implement share functionality
              },
            ),
          ],
        ),
        // Movie content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie title and rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            movie.releaseDate.isNotEmpty
                                ? DateTime.tryParse(movie.releaseDate)?.year.toString() ?? 'N/A'
                                : 'N/A',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Rating
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${movie.voteCount} votes',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Overview
                Text(
                  'Overview',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  movie.overview,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                // Additional info
                _buildInfoRow('Original Title', movie.originalTitle),
                _buildInfoRow('Language', movie.originalLanguage.toUpperCase()),
                _buildInfoRow('Adult Content', movie.adult ? 'Yes' : 'No'),
                _buildInfoRow('Popularity', movie.popularity.toStringAsFixed(0)),
                const SizedBox(height: 24),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implement watch trailer functionality
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Watch Trailer'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Implement add to watchlist functionality
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add to Watchlist'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
