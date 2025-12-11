import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatefulWidget {
  final Widget child;
  
  const MainScaffold({
    super.key,
    required this.child,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _getCurrentIndex(String location) {
    if (location == '/' || location.startsWith('/movies') || location.startsWith('/tv-shows')) {
      return 0;
    } else if (location == '/search') {
      return 1;
    } else if (location == '/favorites') {
      return 2;
    } else if (location == '/profile') {
      return 3;
    }
    return 0;
  }

  void _onBottomNavTap(int index) {
    final currentLocation = GoRouterState.of(context).uri.path;
    switch (index) {
      case 0:
        // If already on home, movies, or tv-shows, stay there
        if (currentLocation == '/' || currentLocation.startsWith('/movies') || currentLocation.startsWith('/tv-shows')) {
          return;
        }
        context.go('/');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/favorites');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _getCurrentIndex(location);
    
    // Don't show bottom nav on auth pages or movie/tv show details
    final hideBottomNav = [
      '/login',
      '/register',
      '/movie',
      '/tv-show',
    ].any((path) => location.startsWith(path));

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: hideBottomNav
          ? null
          : BottomNavigationBar(
              currentIndex: currentIndex > 3 ? 0 : currentIndex,
              onTap: _onBottomNavTap,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.movie),
                  activeIcon: Icon(Icons.movie),
                  label: 'Фільми',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  activeIcon: Icon(Icons.search),
                  label: 'Пошук',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border),
                  activeIcon: Icon(Icons.favorite),
                  label: 'Обране',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Профіль',
                ),
              ],
            ),
    );
  }
}

