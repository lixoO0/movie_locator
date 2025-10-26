import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/movie.dart';
import 'movie_card.dart';

class MovieList extends StatelessWidget {
  final List<Movie> movies;
  final bool hasReachedMax;
  final VoidCallback? onLoadMore;

  const MovieList({
    super.key,
    required this.movies,
    this.hasReachedMax = false,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const Center(
        child: Text('No movies found'),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!hasReachedMax &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            onLoadMore != null) {
          onLoadMore!();
        }
        return false;
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: movies.length + (hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == movies.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final movie = movies[index];
          return MovieCard(
            movie: movie,
            onTap: () => context.go('/movie/${movie.id}'),
          );
        },
      ),
    );
  }
}
