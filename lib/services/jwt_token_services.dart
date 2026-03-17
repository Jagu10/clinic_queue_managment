import 'package:clinic_queue_managment/services/preferences_shared.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class JwtTokenServices{
  JwtTokenServices._();

  static Future<dynamic> getJwtToken() async {
   String? token=await PreferencesShared().getToken();
   return JwtDecoder.isExpired(token!)?null:JwtDecoder.decode(token!);
  }

 static Future<bool?> isAdmin() async {
    String? token=await PreferencesShared().getToken();
    if(JwtDecoder.isExpired(token!)){
      return null;
    }else{
      return JwtDecoder.decode(token)['role']=='admin';
    }
  }
}