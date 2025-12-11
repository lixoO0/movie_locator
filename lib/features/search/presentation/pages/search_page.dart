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
import '../../../../shared/theme/theme_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  int? selectedGenreId;
  int? selectedYear;
  double? minRating;

  @override
  void initState() {
    super.initState();
    context.read<MoviesBloc>().add(const GetMovieGenresEvent());
  }
  
  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }
  
  void _applyFilters() {
    if (_searchController.text.trim().isEmpty) {
      // Use discover when no search query
      context.read<MoviesBloc>().add(DiscoverMoviesEvent(
        genreId: selectedGenreId,
        year: selectedYear,
        minRating: minRating,
        page: 1,
      ));
    } else {
      // When there's a search query, combine with filters using discover
      context.read<MoviesBloc>().add(DiscoverMoviesEvent(
        genreId: selectedGenreId,
        year: selectedYear,
        minRating: minRating,
        page: 1,
      ));
    }
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
          'Пошук',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return IconButton(
                icon: Icon(
                  themeState.isDark ? Icons.light_mode : Icons.dark_mode,
                ),
                tooltip: 'Змінити тему',
                onPressed: () {
                  context.read<ThemeBloc>().add(ToggleThemeEvent());
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Фільтри',
            onPressed: () => _showFilterDialog(context),
          ),
        ],
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
                hintText: 'Пошук фільмів...',
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
                  child: Text('Почніть вводити для пошуку'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Фільтри'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Жанр:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              BlocBuilder<MoviesBloc, MoviesState>(
                builder: (context, state) {
                  if (state is GenresLoaded) {
                    return Wrap(
                      spacing: 8,
                      children: state.genres.map((genre) {
                        final isSelected = selectedGenreId == genre.id;
                        return FilterChip(
                          label: Text(genre.name),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              selectedGenreId = selected ? genre.id : null;
                            });
                          },
                        );
                      }).toList(),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 16),
              const Text('Рік:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: selectedYear?.toString() ?? 'Наприклад: 2023',
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  selectedYear = value.isNotEmpty ? int.tryParse(value) : null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Мінімальний рейтинг:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: minRating?.toString() ?? 'Наприклад: 7.5',
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  minRating = value.isNotEmpty ? double.tryParse(value) : null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedGenreId = null;
                selectedYear = null;
                minRating = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Очистити'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            onPressed: () {
              _applyFilters();
              Navigator.pop(context);
            },
            child: const Text('Застосувати'),
          ),
        ],
      ),
    );
  }
}
