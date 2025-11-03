import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/movies_bloc.dart';
import '../bloc/movies_event.dart';
import '../bloc/movies_state.dart';
import '../widgets/movie_card.dart';
import '../widgets/movie_list.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _onTabChanged(_tabController.index);
      }
    });
    
    // Load initial data
    context.read<MoviesBloc>().add(const GetPopularMoviesEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Load data based on selected tab
    switch (index) {
      case 0:
        context.read<MoviesBloc>().add(const GetPopularMoviesEvent());
        break;
      case 1:
        context.read<MoviesBloc>().add(const GetTopRatedMoviesEvent());
        break;
      case 2:
        context.read<MoviesBloc>().add(const GetNowPlayingMoviesEvent());
        break;
      case 3:
        context.read<MoviesBloc>().add(const GetUpcomingMoviesEvent());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movie Locator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () => context.go('/search'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.local_fire_department), text: 'Popular'),
            Tab(icon: Icon(Icons.star), text: 'Top Rated'),
            Tab(icon: Icon(Icons.play_circle), text: 'Now Playing'),
            Tab(icon: Icon(Icons.upcoming), text: 'Upcoming'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMoviesList(),
          _buildMoviesList(),
          _buildMoviesList(),
          _buildMoviesList(),
        ],
      ),
    );
  }

  Widget _buildMoviesList() {
    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: (context, state) {
        if (state is MoviesLoading) {
          return const LoadingWidget();
        } else if (state is MoviesLoaded) {
          return MovieList(
            movies: state.movies,
            hasReachedMax: state.hasReachedMax,
            onLoadMore: () {
              context.read<MoviesBloc>().add(
                GetPopularMoviesEvent(page: state.currentPage + 1),
              );
            },
          );
        } else if (state is MoviesError) {
          return custom.CustomErrorWidget(message: state.message);
        }
        return const Center(
          child: Text('No movies available'),
        );
      },
    );
  }
}
