import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_project/HS/landingpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: LandingPage(),
    );
  }
}