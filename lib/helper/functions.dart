import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper_functions {
  static String UserLoggedInKey = "UserLoggedInKey";
  static saveUserLoggedDetails({@required bool isLoggedin}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(UserLoggedInKey, isLoggedin);
  }

  static Future<bool> getUserLoggedInDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(UserLoggedInKey);
  }
}
