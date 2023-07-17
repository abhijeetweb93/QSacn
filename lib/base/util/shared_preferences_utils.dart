import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {

  static Future<bool> addMobileNo(String mobileNo) async{
    List<String>? storedList = await getListOfMobileNo();
    if(storedList!=null) {
      storedList.add(mobileNo);
    }else{
      storedList=[];
      storedList.add(mobileNo);
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var isSaved=prefs.setStringList("mobile", storedList.toSet().toList());
    return isSaved;
  }

  static Future<List<String>?> getListOfMobileNo() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? list =  prefs.getStringList('mobile');
    return list;
  }


}