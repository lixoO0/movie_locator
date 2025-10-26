import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/movies_bloc.dart';
import '../bloc/movies_event.dart';
import '../bloc/movies_state.dart';
import '../widgets/movie_card.dart';
import '../widgets/movie_list.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

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
        title: const Text('Movie Locator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.go('/search'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Popular'),
            Tab(text: 'Top Rated'),
            Tab(text: 'Now Playing'),
            Tab(text: 'Upcoming'),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _tabController.animateTo(index);
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
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
          return ErrorWidget(message: state.message);
        }
        return const Center(
          child: Text('No movies available'),
        );
      },
    );
  }
}
