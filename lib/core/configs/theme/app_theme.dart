import 'package:clonespotify/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme{
  static final lightTheme=ThemeData(
    primaryColor:AppColors.primary,
    scaffoldBackgroundColor:AppColors.lightBackground,
    brightness:Brightness.light,
    fontFamily:"Satoshi",
     inputDecorationTheme: InputDecorationTheme(
      filled:true,
      fillColor:Colors.transparent,
      border:OutlineInputBorder(),
      
     ),
    elevatedButtonTheme:ElevatedButtonThemeData(
       style: ElevatedButton.styleFrom(
        backgroundColor:AppColors.primary,
        foregroundColor:Colors.white,
        textStyle: const TextStyle(fontSize:20,fontWeight:FontWeight.bold),
        shape:RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(30)
        )
       ),
    ),
  );
  static final dartTheme=ThemeData(
    primaryColor:AppColors.primary,
    scaffoldBackgroundColor:AppColors.darkBackground,
    brightness:Brightness.dark,
    fontFamily:'Satoshi',
    elevatedButtonTheme:ElevatedButtonThemeData(
       style: ElevatedButton.styleFrom(
        backgroundColor:AppColors.primary,
        foregroundColor:Colors.white,
        textStyle: const TextStyle(fontSize:20,fontWeight:FontWeight.bold),
        shape:RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(30)
        )
       ),
    ),
  );
}