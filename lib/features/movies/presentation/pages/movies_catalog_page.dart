import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movies_bloc.dart';
import '../bloc/movies_event.dart';
import '../bloc/movies_state.dart';
import '../widgets/movie_list.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom;
import '../../../../shared/theme/theme_bloc.dart';

class MoviesCatalogPage extends StatefulWidget {
  const MoviesCatalogPage({super.key});

  @override
  State<MoviesCatalogPage> createState() => _MoviesCatalogPageState();
}

class _MoviesCatalogPageState extends State<MoviesCatalogPage> {
  int? selectedGenreId;
  int? selectedYear;
  double? minRating;
  
  @override
  void initState() {
    super.initState();
    context.read<MoviesBloc>().add(const GetMovieGenresEvent());
    context.read<MoviesBloc>().add(const DiscoverMoviesEvent());
  }
  
  void _applyFilters() {
    // Reset to page 1 when applying filters
    context.read<MoviesBloc>().add(DiscoverMoviesEvent(
      genreId: selectedGenreId,
      year: selectedYear,
      minRating: minRating,
      page: 1,
    ));
  }
  
  void _clearFilters() {
    setState(() {
      selectedGenreId = null;
      selectedYear = null;
      minRating = null;
    });
    context.read<MoviesBloc>().add(const DiscoverMoviesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фільми'),
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
          // Filter chips
          if (selectedGenreId != null || selectedYear != null || minRating != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                children: [
                  if (selectedGenreId != null)
                    Chip(
                      label: const Text('Жанр'),
                      onDeleted: () {
                        setState(() => selectedGenreId = null);
                        _applyFilters();
                      },
                    ),
                  if (selectedYear != null)
                    Chip(
                      label: Text('Рік: $selectedYear'),
                      onDeleted: () {
                        setState(() => selectedYear = null);
                        _applyFilters();
                      },
                    ),
                  if (minRating != null)
                    Chip(
                      label: Text('Рейтинг: ${minRating!.toStringAsFixed(1)}+'),
                      onDeleted: () {
                        setState(() => minRating = null);
                        _applyFilters();
                      },
                    ),
                  TextButton(
                    onPressed: _clearFilters,
                    child: const Text('Очистити'),
                  ),
                ],
              ),
            ),
          // Movies list
          Expanded(
            child: BlocBuilder<MoviesBloc, MoviesState>(
              builder: (context, state) {
                if (state is MoviesLoading) {
                  return const LoadingWidget();
                } else if (state is MoviesLoaded) {
                  // Only show load more if we're on the same filters
                  final canLoadMore = !state.hasReachedMax && state.movies.isNotEmpty;
                  return MovieList(
                    movies: state.movies,
                    hasReachedMax: state.hasReachedMax,
                    onLoadMore: canLoadMore ? () {
                      context.read<MoviesBloc>().add(DiscoverMoviesEvent(
                        genreId: selectedGenreId,
                        year: selectedYear,
                        minRating: minRating,
                        page: state.currentPage + 1,
                      ));
                    } : null,
                  );
                } else if (state is MoviesError) {
                  return custom.CustomErrorWidget(
                    message: state.message,
                    onRetry: _applyFilters,
                  );
                }
                return const Center(child: Text('Немає фільмів'));
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
      builder: (context) => _FilterDialog(
        selectedGenreId: selectedGenreId,
        selectedYear: selectedYear,
        minRating: minRating,
        onApply: (genreId, year, rating) {
          setState(() {
            selectedGenreId = genreId;
            selectedYear = year;
            minRating = rating;
          });
          _applyFilters();
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _FilterDialog extends StatefulWidget {
  final int? selectedGenreId;
  final int? selectedYear;
  final double? minRating;
  final Function(int?, int?, double?) onApply;
  
  const _FilterDialog({
    required this.selectedGenreId,
    required this.selectedYear,
    required this.minRating,
    required this.onApply,
  });
  
  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  int? _genreId;
  int? _year;
  double? _rating;
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _genreId = widget.selectedGenreId;
    _year = widget.selectedYear;
    _rating = widget.minRating;
    if (_year != null) _yearController.text = _year.toString();
    if (_rating != null) _ratingController.text = _rating.toString();
  }
  
  @override
  void dispose() {
    _yearController.dispose();
    _ratingController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                      final isSelected = _genreId == genre.id;
                      return FilterChip(
                        label: Text(genre.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _genreId = selected ? genre.id : null;
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
              controller: _yearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Наприклад: 2023',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _year = value.isNotEmpty ? int.tryParse(value) : null;
              },
            ),
            const SizedBox(height: 16),
            const Text('Мінімальний рейтинг:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _ratingController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'Наприклад: 7.5',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _rating = value.isNotEmpty ? double.tryParse(value) : null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Скасувати'),
        ),
        ElevatedButton(
          onPressed: () => widget.onApply(_genreId, _year, _rating),
          child: const Text('Застосувати'),
        ),
      ],
    );
  }
}

