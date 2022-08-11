import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:senior_project/HS/mainpage.dart';
import 'package:senior_project/HW/addFriend.dart';
import '../HW/friendlist.dart';
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
      resizeToAvoidBottomInset : false,

      appBar: AppBar(
        backgroundColor: const Color(0xff6157DE),
        elevation: 5,
        title: Text(
          "내 정보",
          style: TextStyle(
            fontFamily: 'Leferi',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                  return MainPage();
                }));
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/neoguleman.jpeg',
                fit: BoxFit.contain,
                height: 200,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("사용자닉네임",
                        style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[Text(auth.currentUser!.email.toString())],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Wrap(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 25),
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Menu();
                          }));
                        },
                        child: Text(
                          "나의 친구관리",
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            color: const Color(0xff6157DE),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.all(25),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MainPage();
                        }));
                      },
                      child: Text(
                        "메인페이지",
                        style: TextStyle(
                          fontFamily: 'Leferi',
                          color: const Color(0xff6157DE),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: GestureDetector(
          onTap: () {
            _authentication.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return (login());
            }));
          },
          child: Container(
            padding: EdgeInsets.only(top: 9),
            height: 50,
            color: const Color(0xff6157DE),
            child: Text(
              "로그아웃",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Leferi',
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
