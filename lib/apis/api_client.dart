import 'dart:convert';

import 'package:clinic_queue_managment/services/preferences_shared.dart';
import 'package:http/http.dart' as http;

class ApiClient{
  static const String base_url='https://cmsback.sampaarsh.cloud/';

  Future<http.Response> post(String endpoint,Map<String,dynamic> body) async{
    final token=await PreferencesShared().getToken();
     return await http.post(Uri.parse('$base_url$endpoint'),
      headers:{ 'Content-Type':'application/json','Authorization': 'Bearer $token',},
      body: jsonEncode(body),
    );
  }

  Future<http.Response> get(String endpoint) async {
    final token=await PreferencesShared().getToken();
    final response= await http.get(Uri.parse('$base_url$endpoint'),
      headers: {
      'Content-Type':'application/json',
        'Authorization':'Bearer $token'
      }
    );
    return response;
    // print(token);
    // print(response.statusCode);
  }
}