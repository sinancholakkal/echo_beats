import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Color.fromRGBO(179, 17, 155, 1),
    secondary: Color.fromARGB(255, 210, 66, 174),
    primary: Color.fromARGB(255, 210, 66, 174),
    onPrimary: Colors.white
  ),
  scaffoldBackgroundColor:  Color.fromARGB(255, 179, 17, 155),
  buttonTheme: ButtonThemeData(
    colorScheme: ColorScheme.light(
      primary: Colors.black
    )
  )
);
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Colors.black,
    secondary: Color.fromARGB(255, 57, 13, 38), // Secondary color,
    primary: Color.fromARGB(255, 57, 13, 38),
    onPrimary: Colors.white
    
  ),
  scaffoldBackgroundColor: Colors.black,
  buttonTheme: ButtonThemeData(
    colorScheme: ColorScheme.dark(
      primary: const Color.fromARGB(255, 231, 195, 195)
    )
  )
);