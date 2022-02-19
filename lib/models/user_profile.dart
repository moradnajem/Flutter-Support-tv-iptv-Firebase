import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv/models/user-model.dart';

import '../manger/language.dart';

class UserProfile {
  static final UserProfile shared = UserProfile();

  Future<Language?> getLanguage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var languageIndex = prefs.get('language');
      return languageIndex == null
          ? Language.values[0]
          : Language.values[int.parse(languageIndex.toString())];
    } catch (e) {
      return null;
    }
  }

  setLanguage({ required Language language }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('language', language.index);
    } catch(e) {
      return null;

    }
  }

  Future<UserModel?> getUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.get('user') == ""
          ? null
          : userModelFromJson(prefs.get('user').toString());
    } catch (e) {
      return null;
    }
  }

  setUser({UserModel? user}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', user == null ? "" : userModelToJson(user));
    } catch (e) {}
  }
}
