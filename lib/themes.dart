import 'package:flutter/material.dart';

// Shared properties
String _fontFamily='Roboto';
final _textTheme=TextTheme(
  subhead: TextStyle(fontWeight: FontWeight.w500),
  body1: TextStyle(fontWeight: FontWeight.w500),
  body2: TextStyle(fontWeight: FontWeight.w500),
  button: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),
  caption: TextStyle(fontWeight: FontWeight.w500),
  display1: TextStyle(fontWeight: FontWeight.w500),
  display2: TextStyle(fontWeight: FontWeight.w500),
  display3: TextStyle(fontWeight: FontWeight.w500),
  display4: TextStyle(fontWeight: FontWeight.w500),
  headline: TextStyle(fontWeight: FontWeight.w500),
  overline: TextStyle(fontWeight: FontWeight.w500),
  subtitle: TextStyle(fontWeight: FontWeight.w500),
  title: TextStyle(fontWeight: FontWeight.w500),
);
final ButtonThemeData _buttonTheme=ButtonThemeData(
  buttonColor: Colors.lightBlue[600]
  
);

// Themes
final ThemeData themeLight=new ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  accentColor: Colors.blueAccent,
  fontFamily: _fontFamily,
  // appBarTheme: AppBarTheme(
  //   iconTheme: IconThemeData(
  //     color: Colors.black
  //   ),
  //   color: Colors.white,
  //   textTheme: ThemeData().textTheme.copyWith(
  //     title: ThemeData().textTheme.title.copyWith(fontSize: 20,fontWeight: FontWeight.w400,color:Colors.black)
  //   )
  // ),
  textTheme: TextTheme(
    body1: TextStyle(fontWeight: FontWeight.w500),
    body2: TextStyle(fontWeight: FontWeight.w500),
    button: TextStyle(fontWeight: FontWeight.w500),
    caption: TextStyle(fontWeight: FontWeight.w500),
    subtitle: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade700),
    subhead: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade800),
    title: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade800),
    headline: TextStyle(fontWeight: FontWeight.w400,color:Colors.black.withOpacity(0.73)),
    display1: TextStyle(fontWeight: FontWeight.w500),
    overline: TextStyle(fontWeight: FontWeight.w500),
    display2: TextStyle(fontWeight: FontWeight.w500),
    display3: TextStyle(fontWeight: FontWeight.w500),
    display4: TextStyle(fontWeight: FontWeight.w500),
  )
);

final ThemeData themeDark=new ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.lightBlue[600],
  accentColor: Colors.redAccent,
  appBarTheme: AppBarTheme(
    color: Colors.grey[800]
  ),
  buttonTheme: _buttonTheme,
  fontFamily: _fontFamily,
  textTheme: _textTheme
);