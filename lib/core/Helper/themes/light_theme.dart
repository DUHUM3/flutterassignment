import 'package:flutter/material.dart';

ThemeData lightTheme({Color? bkColor, sfBkColor, btmNvBkColor, btmNvUnSItColor, btmNvSItColor, appBrColor, txtColor}) {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: sfBkColor,
    colorScheme: ColorScheme.light(background: bkColor), // استبدال backgroundColor
    canvasColor: appBrColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: btmNvBkColor,
      unselectedItemColor: btmNvUnSItColor,
      selectedItemColor: btmNvSItColor,
      elevation: 0,
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: appBrColor,
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.normal, // يحدد اللون تلقائيًا
    ),
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      color: appBrColor,
      elevation: 0,
      titleTextStyle: TextStyle( // استبدال textTheme
        color: txtColor,
        fontSize: 20,
      ),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle( // استبدال headline6
        color: txtColor,
        fontSize: 20,
      ),
      headlineMedium: TextStyle( // استبدال headline4
        color: txtColor,
        fontSize: 20,
      ),
      bodyLarge: TextStyle( // استبدال bodyText1
        color: txtColor,
        fontSize: 20,
      ),
    ),
  );
}
