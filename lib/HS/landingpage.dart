import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_project/HS/mainpage.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>{
  @override
  void initState() {
    Timer(Duration(seconds: 3), (){
      Get.offAll(MainPage());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(child: Text("여기로 가")),
        ),
      );
  }
}

