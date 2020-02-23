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

  set showAccountAmount(bool value)=>_prefs.setBool('showAccountAmount', value);
  bool get showAccountAmount =>_prefs.getBool('showAccountAmount')??true;
}