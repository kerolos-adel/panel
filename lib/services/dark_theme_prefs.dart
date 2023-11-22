import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePref{
  // ignore: constant_identifier_names
  static const THEME_STATUS="THEMESTATUS";

  setDarkTheme(bool value)async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.setBool(THEME_STATUS, value);
  }
  Future<bool>getTheme()async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    return sharedPreferences.getBool(THEME_STATUS)??false;
  }
}