import 'package:flutter/material.dart';
import '../../domain/entities/tv_show.dart';
import 'tv_show_card.dart';

class TvShowList extends StatelessWidget {
  final List<TvShow> tvShows;
  final bool hasReachedMax;
  final VoidCallback? onLoadMore;

  const TvShowList({
    super.key,
    required this.tvShows,
    this.hasReachedMax = false,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (tvShows.isEmpty) {
      return const Center(
        child: Text('Немає серіалів'),
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
        itemCount: tvShows.length + (hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == tvShows.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final tvShow = tvShows[index];
          return TvShowCard(tvShow: tvShow);
        },
      ),
    );
  }
}

