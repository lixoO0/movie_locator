import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection.dart';
import 'features/movies/presentation/bloc/movies_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/favorites/presentation/bloc/favorites_bloc.dart';
import 'features/movies/presentation/pages/home_page.dart';
import 'features/movies/presentation/pages/movie_details_page.dart';
import 'features/search/presentation/pages/search_page.dart';
import 'features/favorites/presentation/pages/favorites_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/profile_page.dart';
import 'shared/widgets/main_scaffold.dart';
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
        BlocProvider<AuthBloc>(
          create: (context) {
            final bloc = getIt<AuthBloc>();
            bloc.add(CheckAuthStatusEvent());
            return bloc;
          },
        ),
        BlocProvider<FavoritesBloc>(
          create: (context) => getIt<FavoritesBloc>(),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          final router = GoRouter.of(context);
          if (state is Authenticated) {
            // User logged in - no redirect needed, can access all pages
          } else if (state is Unauthenticated) {
            // Only redirect to login if trying to access protected routes
            final location = router.routerDelegate.currentConfiguration.uri.path;
            final protectedRoutes = ['/favorites', '/profile'];
            if (protectedRoutes.contains(location)) {
              router.go('/login');
            }
          }
        },
        child: MaterialApp.router(
          title: 'Movie Locator',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: createRouter(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // Don't check auth for public routes
      final publicRoutes = ['/', '/search', '/login', '/register'];
      if (publicRoutes.contains(state.matchedLocation)) {
        return null;
      }
      
      // For protected routes, check auth (will be handled by BlocListener)
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MainScaffold(child: const HomePage()),
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
        builder: (context, state) => MainScaffold(child: const SearchPage()),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => MainScaffold(child: const FavoritesPage()),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => MainScaffold(child: const ProfilePage()),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
    ],
  );
}
