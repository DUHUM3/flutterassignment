import 'package:flutter/material.dart';

ThemeData darkTheme({
  Color? bkColor,
  sfBkColor,
  btmNvBkColor,
  btmNvUnSItColor,
  btmNvSItColor,
  appBrColor,
  txtColor,
}) {
  return ThemeData(
    brightness: Brightness.dark, // تحويله إلى الوضع الداكن
    scaffoldBackgroundColor: sfBkColor,
    colorScheme: ColorScheme.dark(background: bkColor), // استبدال backgroundColor
    canvasColor: appBrColor,

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: btmNvBkColor,
      unselectedItemColor: btmNvUnSItColor,
      selectedItemColor: btmNvSItColor,
      elevation: 0,
    ),

    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
    ),
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,

    bottomAppBarTheme: BottomAppBarTheme(
      color: appBrColor,
    ),

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
      displayLarge: TextStyle( // استبدال headline1
        color: txtColor,
        fontSize: 20,
      ),
      labelLarge: TextStyle( // استبدال button
        color: txtColor,
        fontSize: 20,
      ),
    ),
  );
}
