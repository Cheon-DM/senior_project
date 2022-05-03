import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'loginPage.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("내 정보"),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              Image.asset(
                "assets/images/bambi.jpg",
                width: 200,
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("정밤비",
                        style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('userIDsomething')
                  ],
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                child: OutlinedButton(
                    onPressed: () {
                      Get.to(PreLoginPage());
                    },
                    child: Text("로그아웃")),
              ),
            ],

          )
      ),
    );
  }
}