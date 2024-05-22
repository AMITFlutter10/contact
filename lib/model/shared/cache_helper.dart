import 'package:contact/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CacheHelper{

  static  SharedPreferences ? preferences  ;

static Future<void> init()async{
   preferences=  await SharedPreferences.getInstance();
 }
  // String , bool , int , double , list

 static putString({required SharedKeys key , required String value})async {
 await preferences!.setString(key.name , value);
}
  static String getString({required SharedKeys key}){
  return preferences!.getString(key.name)?? "";
}

 static putBOOL({required SharedKeys  key , required bool value})async {
 await preferences!.setBool(key.name, value);
}
  static bool getBOOL({required SharedKeys key}){
  return preferences!.getBool(key.name) ?? false;  // null
}

  putInt({required SharedKeys key , required int value})async {
    await preferences!.setInt(key.name, value);
  }
int getInt({required SharedKeys key}){
  return preferences!.getInt(key.name) ?? 0;
}

 deleteData({required key}){
  preferences!.remove(key);
 }
 deleteCache(){
  preferences!.clear();
 }

}