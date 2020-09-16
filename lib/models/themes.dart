import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.blueGrey,
  brightness: Brightness.dark,
  textTheme: TextTheme(bodyText2: TextStyle(color: Colors.lightBlueAccent),),
  backgroundColor: const Color(0xFF212121),
  accentColor: Colors.white,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.lightBlueAccent,
    hoverColor: Colors.red,
    foregroundColor: Colors.white,
  ),
  dividerColor: Colors.black12,
);

final lightTheme = ThemeData(
    primarySwatch: Colors.grey,
    textTheme: TextTheme(bodyText2: TextStyle(color: Colors.lightBlueAccent),),
    primaryColor: Colors.lightBlueAccent,
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    accentColor: Colors.black,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.lightBlueAccent,
      hoverColor: Colors.red,
      foregroundColor: Colors.white,
    ),
    dividerColor: Colors.white);
