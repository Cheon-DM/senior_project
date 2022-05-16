//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senior_project/DM/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior_project/HW/login.dart';

class signup_complete extends StatefulWidget {

  final String received;
  const signup_complete(this.received);
  @override
  _signup_completeState createState() => _signup_completeState();
}

class _signup_completeState extends State<signup_complete> {


  //late final String userName;
  var name='';
  final user =FirebaseAuth.instance.currentUser;
  //DocumentSnapshot documentSnapshot =await userRe
  //final userData=FirebaseFirestore.instance.collection('user').doc('$code');
  void _sendName()async{
    final user =FirebaseAuth.instance.currentUser;
    final userData= await FirebaseFirestore.instance.collection('user').doc(user!.uid).get();
    name = userData.data()!['userName'];
    print(name);
  }
  //FirebaseAuth auth = FirebaseAuth.instance;


  Scaffold showComplete(userName){
    return Scaffold(
      appBar: AppBar(
        title : Text("회원가입완료"),
      ),
      body: Padding(

          padding: EdgeInsets.all(50),
          child: Column(
            children: <Widget>[
              Text(
                "회원가입이 완료되었습니다.",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Container( height: 30 ),
              Row(
                children: <Widget>[
                  Text("닉네임"),
                  Container(width: 20,),
                  Text(widget.received, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("님")
                ],
              ),
              Container( height: 10 ),
              Row(
                children: <Widget>[
                  Text("아이디"),
                  Container(width: 20,),
                  Text(user!.email.toString()),
                ],
              ),
              Container(height: 100),
              Container(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return login();
                        }));
                  },
                  child: Text("로그인하기"),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.disabled)) { return Colors.grey; }
                      else { return Color(0xff6157de); }
                    }
                    ),
                  ),
                ),
              ),
            ],

          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        _sendName();
        return showComplete(name);

      }
    );
  }
}


