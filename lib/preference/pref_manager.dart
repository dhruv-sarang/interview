import 'package:shared_preferences/shared_preferences.dart';

class PrefManager {
  static const _KEY_NAME = 'name';
  static const _KEY_EMAIL = 'email';
  static const _KEY_PASSWORD = 'password';
  static const _KEY_ISLOGIN = 'isLogin';

  static late SharedPreferences sharedPreferences;

  static Future<SharedPreferences> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (!sharedPreferences.containsKey(_KEY_ISLOGIN)) {
      await sharedPreferences.setBool(_KEY_ISLOGIN, false);
    }
    return sharedPreferences;
  }

  static Future<bool> createAccount(String email, String password) async {
    try {
      // await sharedPreferences.setString(_KEY_NAME, name);
      await sharedPreferences.setString(_KEY_EMAIL, email);
      await sharedPreferences.setString(_KEY_PASSWORD, password);

      return true;
    } catch (e) {
      return false;
    }
  }

  static String getName() {
    return sharedPreferences.getString(PrefManager._KEY_NAME) ?? '';
  }

  static String getEmail() {
    return sharedPreferences.getString(PrefManager._KEY_EMAIL) ?? '';
  }

  static String getPassword() {
    return sharedPreferences.getString(PrefManager._KEY_PASSWORD) ?? '';
  }

  static Future<bool> login(String email) async {
    try {
      await sharedPreferences.setString(_KEY_EMAIL, email);
      await sharedPreferences.setBool(
          _KEY_ISLOGIN, true); // Set login status to true
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> logout() async {
    try {
      await sharedPreferences.setBool(
          _KEY_ISLOGIN, false); // Set login status to false
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool getLoginStatus() {
    return sharedPreferences.getBool(_KEY_ISLOGIN) ?? false;
  }
}
