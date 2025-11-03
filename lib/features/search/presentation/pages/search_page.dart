import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../../movies/presentation/bloc/movies_bloc.dart';
import '../../../movies/presentation/bloc/movies_event.dart';
import '../../../movies/presentation/bloc/movies_state.dart';
import '../../../movies/presentation/widgets/movie_card.dart';
import '../../../movies/presentation/widgets/loading_widget.dart';
import '../../../movies/presentation/widgets/error_widget.dart' as custom;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // If query is empty, don't search
    if (query.trim().isEmpty) {
      setState(() {});
      return;
    }

    // Set new timer for debounce (500ms delay)
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      context.read<MoviesBloc>().add(SearchMoviesEvent(query: query.trim()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Movies',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Search for movies...',
                prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _debounceTimer?.cancel();
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {});
                _onSearchChanged(value);
              },
              onSubmitted: (value) {
                _debounceTimer?.cancel();
                if (value.trim().isNotEmpty) {
                  context.read<MoviesBloc>().add(SearchMoviesEvent(query: value.trim()));
                }
              },
            ),
          ),
          // Search results
          Expanded(
            child: BlocBuilder<MoviesBloc, MoviesState>(
              builder: (context, state) {
                // Show placeholder if no search query
                if (_searchController.text.trim().isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Search for movies',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter a movie title to get started',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[500],
                              ),
                        ),
                      ],
                    ),
                  );
                }

                // Show loading state
                if (state is MoviesLoading) {
                  return const LoadingWidget();
                }

                // Show error state
                if (state is MoviesError) {
                  return custom.CustomErrorWidget(
                    message: state.message,
                    onRetry: () {
                      if (_searchController.text.trim().isNotEmpty) {
                        context.read<MoviesBloc>().add(
                              SearchMoviesEvent(query: _searchController.text.trim()),
                            );
                      }
                    },
                  );
                }

                // Show results
                if (state is MoviesLoaded) {
                  if (state.movies.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.movie_filter_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No movies found',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try a different search term',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[500],
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      return MovieCard(
                        movie: movie,
                        onTap: () => context.go('/movie/${movie.id}'),
                      );
                    },
                  );
                }

                // Default state
                return const Center(
                  child: Text('Start typing to search'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
