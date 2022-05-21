import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:senior_project/HS/mainpage.dart';
import 'package:senior_project/HW/addFriend.dart';
import '../HW/login.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  final _authentication = FirebaseAuth.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

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
                "assets/assets/bambi.jpg",
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
                    Text("여기 아직 구현 못함 ㅠ",
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
                    Text(auth.currentUser!.email.toString())
                  ],
                ),
              ),

              SizedBox(
                height: 50,
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return AddFriend();
                          }));
                    },
                    child: Text("나의 친구관리")
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return MainPage();
                          }));
                    },
                    child: Text("메인페이지")
                ),
              ),


              SizedBox(
                height: 50,
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                child: OutlinedButton(
                    onPressed: () {
                      _authentication.signOut();
                      /*Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return (login());
                          }));*/
                      Get.offAll(() => login());

                    },
                    child: Text("로그아웃")),
              ),
            ],

          )
      ),
    );
  }
}