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
import 'db/models/User.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  
  await DB.init();

  final prefs=new SharedPrefService();
  await prefs.initPrefs();
  
  if(prefs.openFirstTimeApp){
    prefs.openFirstTimeApp=false;
    User.add(User())
      .then((int id)async{
        await Account.add(Account(name: 'Efectivo',idUser: id,orderCustom: 0));
      });
  }
  Intl.defaultLocale = 'es_US';

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TransactionBloc>(
          create: (BuildContext context) => TransactionBloc(),
        )
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