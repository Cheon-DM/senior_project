import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/HW/login.dart';
import 'action_guide2.dart';

import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;


class ShowGuide extends StatefulWidget {
  @override
  _ShowGuideState createState() => _ShowGuideState();
}


class _ShowGuideState extends State<ShowGuide> {
  final ScrollController _scrollController = ScrollController();

  String data = 'empty';
  fetchFileData() async {
    String responseText;
    responseText = await rootBundle.loadString('assets/guide/guide1_1.txt');

    setState(() {
      data = responseText;
    });
  }

  @override
  void initState() {
    fetchFileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'show-guide',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff6157DE),
          elevation: 5,
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
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ActionGuide2();
              }));
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),


        body: Scrollbar(
          controller: _scrollController,
         isAlwaysShown: true,
         thickness: 10,
         child: ListView(
           controller: _scrollController,
           children: [
             Expanded(
               child: Center(
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text(
                         data,
                         style: TextStyle(fontSize: 18),
                       ),
                     ),
                   ),
               ),
           ],
         ),
        ),
      ),
    );
  }
}