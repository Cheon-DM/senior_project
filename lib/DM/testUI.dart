import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_project/DM/map.dart';

class testUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'testUI',
      home: Scaffold(
        resizeToAvoidBottomInset : false,

        appBar: AppBar(
          title: Text('testUI demo'),
        ),
        body: Center(
          child: OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => KakaoMapTest()));
              },
              child: Text("네비")
          ),
        ),
      ),
    );
  }
}