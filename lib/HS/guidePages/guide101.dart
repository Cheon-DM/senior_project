import 'package:flutter/material.dart';
import 'package:senior_project/HS/action_guide.dart';

import '../mainpage.dart';

class Guide101 extends StatefulWidget {
  @override
  _Guide101 createState() => _Guide101();
}

class _Guide101 extends State<Guide101> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guide101',

      home: Scaffold(
        resizeToAvoidBottomInset: false,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 5,
          title: Text(
            "행동지침1",
            style: TextStyle(
              fontFamily: 'Leferi',
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: (){
              // Get.to(MainPage());
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return ActionGuide();
                  }));
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),

        body: SafeArea(
          child: Container(

          ),

        ),
      ),
    );
  }

}