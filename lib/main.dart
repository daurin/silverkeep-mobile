import 'package:flutter/material.dart';
import 'package:silverkeep/services/SharedPrefService.dart';
import 'package:silverkeep/themes.dart';
import 'package:silverkeep/modules/home/HomePage.dart';

import 'db/DB.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  
  await DB.init();

  final prefs=new SharedPrefService();
  await prefs.initPrefs();
  
  runApp(MyApp());
}

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