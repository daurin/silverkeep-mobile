import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:silverkeep/db/models/Account.dart';
import 'package:silverkeep/services/SharedPrefService.dart';
import 'package:silverkeep/themes.dart';
import 'package:silverkeep/modules/home/HomePage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'blocs/transaction/TransactionBloc.dart';
import 'db/DB.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  
  await DB.init();
  Intl.defaultLocale = 'es_US';

  // final prefs=new SharedPrefService();
  // await prefs.initPrefs();
  // if(prefs.openFirstTimeApp){
  //   prefs.openFirstTimeApp=false;
  //   await DB.initData();
  // }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
      .addPostFrameCallback((_)async{
        final prefs=new SharedPrefService();
        await prefs.initPrefs();
        if(prefs.openFirstTimeApp){
          prefs.openFirstTimeApp=false;
          await DB.initData();
        }

      });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TransactionBloc>(create: (BuildContext context) => TransactionBloc(),),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home:HomePage(),
        theme: buildThemeLight(context),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        locale: Locale('es','US'),
        supportedLocales: [
          const Locale('es','US')
          //const Locale('en', 'US'),
        ],
      ),
    );
  }
}