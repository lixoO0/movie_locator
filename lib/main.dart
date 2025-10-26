import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection.dart';
import 'features/movies/presentation/bloc/movies_bloc.dart';
import 'features/movies/presentation/pages/home_page.dart';
import 'features/movies/presentation/pages/movie_details_page.dart';
import 'features/search/presentation/pages/search_page.dart';
import 'features/favorites/presentation/pages/favorites_page.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Configure dependencies
  await configureDependencies();
  
  runApp(const MovieLocatorApp());
}

class MovieLocatorApp extends StatelessWidget {
  const MovieLocatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MoviesBloc>(
          create: (context) => getIt<MoviesBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Movie Locator',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/movie/:id',
      builder: (context, state) {
        final movieId = int.parse(state.pathParameters['id']!);
        return MovieDetailsPage(movieId: movieId);
      },
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesPage(),
    ),
  ],
);
