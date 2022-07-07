import 'dart:async';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'mainpage.dart';



class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>{

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context)=>MainPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
          color: const Color(0xff6157de),
          child: FractionallySizedBox(
            widthFactor: 0.35,
            heightFactor: 0.35,
            child: Image.asset('assets/logo_white.png'),
          ),
    ),
    );
  }
}