import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../apis/api_client.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  ApiClient apiClient = ApiClient();
  List appoinments=[];
  final _key =GlobalKey<FormState>();

  TextEditingController dateController=TextEditingController();
  TextEditingController timeController=TextEditingController();

  @override
  void initstate(){
    super.initState();
getAppointments();
  }

  Future<void> getAppointments() async {
    http.Response response = await apiClient.get('appointments');

    if (response.statusCode == 200) {
      setState(() {
        appoinments = jsonDecode(response.body);
      });
    }
  }

  Future<void> createAppointment() async {
    if (!_key.currentState!.validate()) return;

    final today = DateTime.now();
    final selectedDate = DateTime.parse(dateController.text);
    if (selectedDate.isBefore(DateTime(today.year, today.month, today.day))) {
      return;
    }

    final body = {
      "appointmentDate": dateController.text,
      "timeSlot": timeController.text,
    };

    http.Response response = await apiClient.post('appointments', body);
     print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {

      dateController.clear();
      timeController.clear();

      await getAppointments();
    } else {
      print("Failed to create appointment");
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patient'),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            children: [
              Form(
                  key: _key,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: dateController,
                        decoration: InputDecoration(
                            labelText: "date(yyy-mm-dd)",

                        ),
                        validator: (v)=>v!.isEmpty?"enter date":null,
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: timeController,
                        decoration: InputDecoration(
                          labelText: "time(hh:mm)",
                        ),
                        validator: (v)=>v!.isEmpty?"enter time":null,
                      ),
                      SizedBox(height: 20,),

                      ElevatedButton(onPressed: createAppointment, child: Text('crete'))
                    ],
                  )),
              Expanded(
                child: appoinments.isEmpty
                    ? const Center(child: Text("No Appointments"))
                    : ListView.builder(
                  itemCount: appoinments.length,
                  itemBuilder: (context, index) {
                    final item = appoinments[index];
                    final queue = item['queueEntry'];

                    return Card(
                      child: ListTile(
                       title: Text("Date: ${item['date']} "),
                        subtitle: Text("Time: ${item['timeSlot']}"),
                      ),
                    );
                  },
                ),
              ),]
        ),
      ),
    );
  }
}
