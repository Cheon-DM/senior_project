import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'mainpage.dart';

class ActionGuide extends StatefulWidget {
  @override
  _ActionGuideState createState() => _ActionGuideState();
}

class _ActionGuideState extends State<ActionGuide> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '행동지침1',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff6157DE),
            elevation: 0,
            title: Text(
              "행동지침",
              style: TextStyle(
                fontFamily: 'Leferi',
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              onPressed: (){
                // Get.to(MainPage());
                Get.offAll(() => MainPage());
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                ExpansionTile(
                  title: Text('정보1'),
                  children: <Widget>[
                    ListTile(
                      title: Text('정보1.1'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text('정보1.2'),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
