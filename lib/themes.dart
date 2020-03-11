import 'package:flutter/material.dart';

// Shared properties
String _fontFamily='Roboto';

ThemeData buildThemeLight(BuildContext context){
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blueAccent,
    //accentColor: Colors.greenAccent,
    fontFamily: _fontFamily,
    appBarTheme: AppBarTheme(
      color: Colors.white,
      iconTheme: Theme.of(context).iconTheme,
      textTheme: Theme.of(context).textTheme,
      actionsIconTheme: IconThemeData(
        color: Colors.black
      ),
    ),
    tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
      labelColor: Colors.black
    ),
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
}