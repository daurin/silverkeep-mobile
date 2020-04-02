import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  
  static final SharedPrefService _instance = SharedPrefService._internal();
  SharedPreferences _prefs;

  factory SharedPrefService() {
    return _instance;
  }
  SharedPrefService._internal();

  initPrefs()async{
    this._prefs=await SharedPreferences.getInstance();
  }

  set showAmount(bool value)=>_prefs.setBool('showAmount', value);
  bool get showAmount =>_prefs.getBool('showAmount')??true;

  set openFirstTimeApp(bool value)=>_prefs.setBool('openFirstTimeApp', value);
  bool get openFirstTimeApp =>_prefs.getBool('openFirstTimeApp')??true;
}