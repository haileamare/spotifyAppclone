
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode>{
  ThemeCubit():super(ThemeMode.light);
  void UpdateTheme(ThemeMode mode){
      debugPrint('Gesture tapped → updating theme to $mode');

    emit(mode);
  }
  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    final themeString=json['theme'] as String?;
    if(themeString=='light'){
      return ThemeMode.light;
    }
    if(themeString=='dark'){
      return ThemeMode.dark;
    } 
    if(themeString=='system'){
      return ThemeMode.system;
    }
    return ThemeMode.light;
  }

 @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {
      'theme': state.toString().split('.').last,
    };
  }
}