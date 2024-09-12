import 'package:flutter/material.dart';

//Light-----
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Color.fromRGBO(179, 17, 155, 1),
    secondary: Color.fromARGB(255, 210, 66, 174),
    primary: Color.fromARGB(255, 210, 66, 174),
    onPrimary: Colors.white,
    secondaryContainer: Colors.white,
  ),
  scaffoldBackgroundColor:  const Color.fromARGB(255, 179, 17, 155),
  buttonTheme: const ButtonThemeData(
    colorScheme: ColorScheme.light(
      primary: Colors.black
    )
  )
);

//Dark------------------
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Colors.black,
    secondary: Color.fromARGB(255, 57, 13, 38), // Secondary color,
    primary: Color.fromARGB(255, 57, 13, 38),
    onPrimary: Colors.white,
    secondaryContainer: Color.fromARGB(167, 0, 0, 0),
    
  ),
  scaffoldBackgroundColor: Colors.black,
  buttonTheme: const ButtonThemeData(
    colorScheme: ColorScheme.dark(
      primary: Color.fromARGB(255, 231, 195, 195)
    )
  )
);