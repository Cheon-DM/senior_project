import 'dart:async';

import 'package:flutter/material.dart';
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
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) => MainPage()), (route) => false,);
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
            child: Image.asset('assets/images/logo_white.png'),
          ),
    ),
    );
  }
}