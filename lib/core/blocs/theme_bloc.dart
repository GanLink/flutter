import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class LoadTheme extends ThemeEvent {
  const LoadTheme();
}

class ToggleTheme extends ThemeEvent {
  const ToggleTheme();
}

class SetDarkMode extends ThemeEvent {
  final bool isDark;

  const SetDarkMode(this.isDark);

  @override
  List<Object?> get props => [isDark];
}

// State
class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState({this.themeMode = ThemeMode.light});

  bool get isDarkMode => themeMode == ThemeMode.dark;

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }

  @override
  List<Object?> get props => [themeMode];
}

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _darkModeKey = 'dark_mode_enabled';

  ThemeBloc() : super(const ThemeState()) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
    on<SetDarkMode>(_onSetDarkMode);
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_darkModeKey) ?? false;
    emit(state.copyWith(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
    ));
  }

  Future<void> _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    final newMode = state.isDarkMode ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, newMode == ThemeMode.dark);
    emit(state.copyWith(themeMode: newMode));
  }

  Future<void> _onSetDarkMode(SetDarkMode event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, event.isDark);
    emit(state.copyWith(
      themeMode: event.isDark ? ThemeMode.dark : ThemeMode.light,
    ));
  }
}
