import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../apis/api_client.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  ApiClient apiClient = ApiClient();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doctor'),),
    );
  }
}
