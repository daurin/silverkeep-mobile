import 'package:flutter/material.dart';
import 'package:silverkeep/themes.dart';
import 'package:silverkeep/widgets/accounts/AccountPage.dart';
import 'package:silverkeep/widgets/home/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeLight,
      home:HomePage()
    );
  }
}