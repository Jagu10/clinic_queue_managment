import 'dart:convert';

import 'package:clinic_queue_managment/apis/api_client.dart';
import 'package:clinic_queue_managment/screens/admin_screen.dart';
import 'package:clinic_queue_managment/screens/doctor_screen.dart';
import 'package:clinic_queue_managment/screens/patient_screen.dart';
import 'package:clinic_queue_managment/screens/receptionist_screen.dart';
import 'package:clinic_queue_managment/services/jwt_token_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/preferences_shared.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ApiClient apiclient = ApiClient();


  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;
    final email = emailController.text.toString();
    final password = passwordController.text.toString();
    http.Response response = await apiclient.post('auth/login',
      {
        "email": email,
        "password": password,
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print(data);
      await PreferencesShared().storeToken(data['token']);
      final role = data['user']['role'].toString();
      navigateByRole(role);
    } else {
      print('error');
  }
}

void navigateByRole(String role) {
   if (role == "doctor") {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => DoctorScreen()),
    );
  } else if (role == "receptionist") {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ReceptionistScreen()),
    );
  } else if (role == "patient") {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => PatientScreen()),
    );
  } else {
     Navigator.pushReplacement(
       context,
       MaterialPageRoute(builder: (_) => AdminScreen()),
     );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LoginScreen'),
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: "Emial",
                    border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: login, child: Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}
