import 'dart:convert';

import 'package:clinic_queue_managment/apis/api_client.dart';
import 'package:clinic_queue_managment/screens/user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:http/http.dart' as http;

import '../model/clinic_model.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  ApiClient apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    getClinic();
  }

  List<ClinicModel> clinicList = [];

  Future<void> getClinic() async {
    http.Response response = await apiClient.get('admin/clinic');
    if (response.statusCode == 200) {
      setState(() {
        clinicList = [ClinicModel.fromJson(jsonDecode(response.body))];
      });
    } else {
      throw Exception('fail to load clinic');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clinic Queue'),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminScreen(),));
            
          },icon: Text('MY CLINIC'),),

          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserScreen(),));

          },icon: Text('USER'),),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: clinicList.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text('${clinicList[index].name}'),
                  subtitle: Text(
                    ' code : ${clinicList[index].code}\n createdAt : ${clinicList[index].createdAt}\nappointmentCount : ${clinicList[index].appointmentCount}\n queueCount : ${clinicList[index].queueCount}\n',
                  ),
                ),
              );
            },
          )),
    );
  }
}
