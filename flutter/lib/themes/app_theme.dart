import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color.fromARGB(255, 228, 105, 102);
  static const Color secundary = Color.fromARGB(255, 170, 159, 219);

  static const Color primaryDark = Color.fromARGB(197, 218, 24, 24);
  static const Color secundaryDark = Color.fromARGB(255, 20, 5, 87);

  //Configuracion del tema claro
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    //Color primario
    primaryColor: primary,
    //AppBar Theme
    appBarTheme: const AppBarTheme(color: primary, elevation: 0),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary, elevation: 5),
  );

  //Configuracion del tema oscuro
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    //Color primario
    primaryColor: primaryDark,
    //AppBar Theme
    appBarTheme: const AppBarTheme(color: primaryDark, elevation: 0),
    scaffoldBackgroundColor: Colors.black87,

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryDark, elevation: 5),
  );
}
