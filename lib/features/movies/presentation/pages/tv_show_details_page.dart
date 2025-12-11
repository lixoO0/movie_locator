import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/movies_bloc.dart';
import '../bloc/movies_event.dart';
import '../bloc/movies_state.dart';
import '../../domain/entities/tv_show.dart';
import '../../domain/entities/video.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom;
import '../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../../favorites/presentation/bloc/favorites_event.dart';
import '../../../favorites/presentation/bloc/favorites_state.dart';
import '../../../favorites/domain/entities/favorite_movie.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class TvShowDetailsPage extends StatefulWidget {
  final int tvId;

  const TvShowDetailsPage({
    super.key,
    required this.tvId,
  });

  @override
  State<TvShowDetailsPage> createState() => _TvShowDetailsPageState();
}

class _TvShowDetailsPageState extends State<TvShowDetailsPage> {
  bool _isFavorite = false;
  
  @override
  void initState() {
    super.initState();
    // Load TV show details and videos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MoviesBloc>().add(GetTvShowDetailsEvent(tvId: widget.tvId));
      context.read<MoviesBloc>().add(GetTvShowVideosEvent(tvId: widget.tvId));
      context.read<FavoritesBloc>().add(CheckFavoriteEvent(widget.tvId));
    });
  }
  
  Future<void> _playTrailer(Video video) async {
    try {
      final url = Uri.parse(video.youtubeUrl);
      final launched = await launchUrl(
        url,
        mode: LaunchMode.platformDefault,
      );
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не вдалося відкрити трейлер')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка: ${e.toString()}')),
        );
      }
    }
  }
  
  void _toggleFavorite(TvShow tvShow) {
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
      context.read<FavoritesBloc>().add(RemoveFavoriteEvent(tvShow.id));
    } else {
      final favorite = FavoriteMovie(
        id: tvShow.id,
        title: tvShow.name,
        overview: tvShow.overview,
        voteAverage: tvShow.voteAverage,
        posterPath: tvShow.posterPath,
        type: 'tv',
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
          buildWhen: (previous, current) {
            // Only rebuild for TV show details states
            return current is TvShowDetailsLoading ||
                   current is TvShowDetailsLoaded ||
                   current is TvShowDetailsError;
          },
          builder: (context, state) {
            if (state is TvShowDetailsLoading) {
              return const LoadingWidget();
            } else if (state is TvShowDetailsLoaded) {
              return _buildTvShowDetails(state.tvShow);
            } else if (state is TvShowDetailsError) {
              return custom.CustomErrorWidget(
                message: state.message,
                onRetry: () {
                  context.read<MoviesBloc>().add(GetTvShowDetailsEvent(tvId: widget.tvId));
                },
              );
            }
            // Show loading while waiting for data
            return const LoadingWidget();
          },
        ),
      ),
    );
  }

  Widget _buildTvShowDetails(TvShow tvShow) {
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
                if (tvShow.backdropPath != null)
                  CachedNetworkImage(
                    imageUrl: '${AppConstants.tmdbImageBaseUrl}/${AppConstants.imageSizeLarge}${tvShow.backdropPath}',
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
                        Icons.tv,
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
                if (favoritesState is FavoriteStatusChecked && favoritesState.id == tvShow.id) {
                  _isFavorite = favoritesState.isFavorite;
                }
                return IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : null,
                  ),
                  tooltip: _isFavorite ? 'Remove from favorites' : 'Add to favorites',
                  onPressed: () => _toggleFavorite(tvShow),
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
        // TV Show content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TV Show title and rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tvShow.name,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tvShow.firstAirDate.isNotEmpty
                                ? DateTime.tryParse(tvShow.firstAirDate)?.year.toString() ?? 'N/A'
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
                            tvShow.voteAverage.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${tvShow.voteCount} votes',
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
                  tvShow.overview,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                // Additional info
                _buildInfoRow('Original Name', tvShow.originalName),
                _buildInfoRow('Language', tvShow.originalLanguage.toUpperCase()),
                _buildInfoRow('First Air Date', tvShow.firstAirDate.isNotEmpty 
                    ? tvShow.firstAirDate 
                    : 'N/A'),
                _buildInfoRow('Popularity', tvShow.popularity.toStringAsFixed(0)),
                if (tvShow.originCountry.isNotEmpty)
                  _buildInfoRow('Origin Country', tvShow.originCountry.join(', ')),
                const SizedBox(height: 24),
                // Trailers section
                BlocBuilder<MoviesBloc, MoviesState>(
                  buildWhen: (previous, current) {
                    return current is VideosLoading ||
                           current is VideosLoaded ||
                           current is VideosError;
                  },
                  builder: (context, state) {
                    if (state is VideosLoaded && state.videos.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Трейлери',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.videos.length,
                              itemBuilder: (context, index) {
                                final video = state.videos[index];
                                return Container(
                                  width: 300,
                                  margin: const EdgeInsets.only(right: 16),
                                  child: Card(
                                    child: InkWell(
                                      onTap: () => _playTrailer(video),
                                      child: Stack(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: video.youtubeThumbnailUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            errorWidget: (context, url, error) => Container(
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.play_circle_outline),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.7),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 8,
                                            left: 8,
                                            right: 8,
                                            child: Text(
                                              video.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 4,
                                                  ),
                                                ],
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    } else if (state is VideosLoading) {
                      return const SizedBox(
                        height: 50,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is VideosError) {
                      return const SizedBox.shrink();
                    }
                    return const SizedBox.shrink();
                  },
                ),
                // Action buttons
                BlocBuilder<MoviesBloc, MoviesState>(
                  buildWhen: (previous, current) {
                    return current is VideosLoading ||
                           current is VideosLoaded ||
                           current is VideosError;
                  },
                  builder: (context, state) {
                    if (state is VideosLoaded && state.videos.isNotEmpty) {
                      return Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _playTrailer(state.videos.first),
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Дивитися трейлер'),
                            ),
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: null,
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Дивитися трейлер'),
                          ),
                        ),
                      ],
                    );
                  },
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

