import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences prefs;
  static const String _themeKey = 'theme_mode';
  
  ThemeBloc({required this.prefs}) : super(ThemeState(themeMode: ThemeMode.system)) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeEvent>(_onSetTheme);
    
    // Load saved theme on initialization
    add(LoadThemeEvent());
  }
  
  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final themeModeString = prefs.getString(_themeKey);
      ThemeMode themeMode = ThemeMode.system;
      
      if (themeModeString != null) {
        switch (themeModeString) {
          case 'light':
            themeMode = ThemeMode.light;
            break;
          case 'dark':
            themeMode = ThemeMode.dark;
            break;
          case 'system':
          default:
            themeMode = ThemeMode.system;
            break;
        }
      }
      
      emit(ThemeState(themeMode: themeMode));
    } catch (e) {
      emit(ThemeState(themeMode: ThemeMode.system));
    }
  }
  
  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final currentMode = state.themeMode;
    ThemeMode newMode;
    
    // Determine current effective theme (if system, check actual brightness)
    if (currentMode == ThemeMode.system) {
      // If system mode, default to light, then toggle to dark
      newMode = ThemeMode.dark;
    } else if (currentMode == ThemeMode.light) {
      newMode = ThemeMode.dark;
    } else {
      newMode = ThemeMode.light;
    }
    
    await prefs.setString(_themeKey, _themeModeToString(newMode));
    emit(ThemeState(themeMode: newMode));
  }
  
  Future<void> _onSetTheme(
    SetThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await prefs.setString(_themeKey, _themeModeToString(event.themeMode));
    emit(ThemeState(themeMode: event.themeMode));
  }
  
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}

abstract class ThemeEvent {}

class LoadThemeEvent extends ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

class SetThemeEvent extends ThemeEvent {
  final ThemeMode themeMode;
  
  SetThemeEvent({required this.themeMode});
}

class ThemeState {
  final ThemeMode themeMode;
  
  ThemeState({required this.themeMode});
  
  bool get isDark => themeMode == ThemeMode.dark;
  bool get isLight => themeMode == ThemeMode.light;
  bool get isSystem => themeMode == ThemeMode.system;
}

