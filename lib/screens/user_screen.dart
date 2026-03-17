import 'dart:convert';

import 'package:clinic_queue_managment/apis/api_client.dart';
import 'package:clinic_queue_managment/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  ApiClient apiClient = ApiClient();
  List<UserModel> userList = [];

  final _key=GlobalKey<FormState>();

  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController roleController=TextEditingController();
  TextEditingController phoneController=TextEditingController();

  String selectedRole = "Patient";

  @override
  void initState() {
    super.initState();
    getUSer();
  }

  Future<void> getUSer() async {
    http.Response response = await apiClient.get('admin/users');
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      setState(() {
        userList = data.map((e) => UserModel.fromJson(e)).toList();
      });
    } else {
      throw Exception('fail to load user');
    }
  }


  Future<void> addUser() async {
    if(!_key.currentState!.validate()) return ;
    final body={
      "name":nameController.text,
      "email":emailController.text,
      "phone":phoneController.text,
      "role":selectedRole,
      "password":passwordController.text,

    };
    http.Response response = await apiClient.post('admin/users',body);
    if(response.statusCode==200 || response.statusCode==201) {
      await getUSer();

      nameController.clear();
      emailController.clear();
      passwordController.clear();
      roleController.clear();
      phoneController.clear();

    }
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UserScreen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: _key,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                      ),
                      validator: (v)=>v!.isEmpty?"enter name":null,
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "password must be 6 char"
                      ),
                      validator: (v)=>v!.isEmpty?"enter email":null,
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                      ),
                      validator: (v)=>v!.isEmpty?"enter Password":null,
                    ),
                    SizedBox(height: 20,),
                    // TextFormField(
                    //   controller: roleController,
                    //   decoration: InputDecoration(
                    //     labelText: "Role",
                    //   ),
                    //   validator: (v)=>v!.isEmpty?"enter role":null,
                    // ),
                    DropdownButtonFormField(
                      value: selectedRole,
                      items: ["Admin", "Receptionist", "Doctor", "Patient"]
                          .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value!;
                        });
                      },
                      decoration: InputDecoration(labelText: "Role"),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: "Phone",
                      ),
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(onPressed: addUser, child: Text('Add'))
                  ],
                )),
            Expanded(child:
            userList.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Role')),
                      DataColumn(label: Text('Phone'))
                    ],
                    rows: userList.map((user) {
                      return DataRow(
                        cells: [
                          DataCell(Text(user.name ?? '')),
                          DataCell(Text(user.email ?? '')),
                          DataCell(Text(user.role ?? '')),
                          DataCell(Text(user.phone ?? '')),
                        ],
                      );
                    }).toList(),
                  ))),]
        ),
      ),
    );
  }
}
