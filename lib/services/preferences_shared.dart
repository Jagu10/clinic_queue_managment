import 'package:shared_preferences/shared_preferences.dart';

class PreferencesShared {

  Future<void> storeToken(String token) async {
    final prefrences = await SharedPreferences.getInstance();
    await prefrences.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefrences = await SharedPreferences.getInstance();
    return prefrences.getString('token');
  }
}
