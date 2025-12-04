import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';

ThemeData light({Color color = const Color.fromARGB(255, 255, 255, 255)}) => ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: color,
  secondaryHeaderColor: const Color.fromARGB(255, 64, 63, 63),
  disabledColor: const Color(0xFF939393),
  brightness: Brightness.light,
  hintColor: const Color.fromARGB(255, 71, 71, 71),
  cardColor: Color.fromARGB(255, 243, 243, 243),
  shadowColor: Colors.black.withValues(alpha: 0.03),
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: Color.fromARGB(
      255, 179, 174, 174))),
  colorScheme: ColorScheme.light(primary: color, secondary: color).copyWith(
      surface: const Color(0xFFFFFFFF)).copyWith(error: const Color(0xFFE84D4F)),
  popupMenuTheme: const PopupMenuThemeData(color: Colors.white, surfaceTintColor: Colors.white),
  dialogTheme: const DialogThemeData(surfaceTintColor: Colors.white),
  floatingActionButtonTheme: FloatingActionButtonThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(500))),
  bottomAppBarTheme: const BottomAppBarThemeData(
    surfaceTintColor: Color.fromARGB(221, 83, 70, 13), height: 60,
    padding: EdgeInsets.symmetric(vertical: 5),
  ),
  dividerTheme: const DividerThemeData(thickness: 0.2, color: Color.fromARGB(255, 108, 136, 165)),
  tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent),
);