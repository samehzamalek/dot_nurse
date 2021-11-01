import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {

  static   SharedPreferences sharedPreferences ;
  static init ()async{
    sharedPreferences = await SharedPreferences.getInstance();
  }
static Future<bool> setStringList({
  @required String key,
  @required List<String> value,
})async{
return await sharedPreferences.setStringList(key, value);
}
  static  Future<List<String>>  getStringList({

         @required  String key,

  }) async {
    sharedPreferences = await SharedPreferences.getInstance();
    return  sharedPreferences.getStringList(key);

  }

}