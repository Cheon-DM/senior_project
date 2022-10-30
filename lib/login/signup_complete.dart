import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior_project/login/login.dart';

class signup_complete extends StatefulWidget {
  final String received;
  const signup_complete(this.received);
  @override
  _signup_completeState createState() => _signup_completeState();
}

class _signup_completeState extends State<signup_complete> {
  var name = '';
  final user = FirebaseAuth.instance.currentUser;

  void _sendName() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    name = userData.data()!['userName'];
    print(name);
  }

  Scaffold showComplete(userName) {
    return Scaffold(
      resizeToAvoidBottomInset : false,

      appBar: AppBar(
        backgroundColor: const Color(0xff6157DE),
        elevation: 5,
        title: Text(
          "회원가입완료",
          style: TextStyle(
            fontFamily: 'Leferi',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(50),
          child: Column(
            children: <Widget>[
              Text(
                "회원가입이 완료되었습니다.",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Leferi',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Container(height: 30),
              Row(
                children: <Widget>[
                  Text(
                    "닉네임",
                    style: TextStyle(
                      fontFamily: 'Leferi',
                    ),
                  ),
                  Container(
                    width: 20,
                  ),
                  Text(widget.received,
                      style: const TextStyle(
                          fontFamily: 'Leferi',
                          fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "님",
                    style: TextStyle(
                      fontFamily: 'Leferi',
                    ),
                  ),
                ],
              ),
              Container(height: 10),
              Row(
                children: <Widget>[
                  Text(
                      "아이디",
                    style: TextStyle(
                      fontFamily: 'Leferi',
                    ),
                  ),
                  Container(
                    width: 20,
                  ),
                  Text(user!.email.toString(),
                    style: TextStyle(
                      fontFamily: 'Leferi',
                    ),),
                ],
              ),
              Container(height: 100),
              Container(
                width: double.maxFinite,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return login();
                    }));
                  },
                  child: Text(
                      "로그인하기",
                    style: TextStyle(
                      fontFamily: 'Leferi',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      } else {
                        return Color(0xff6157de);
                      }
                    }),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      _sendName();
      return showComplete(name);
    });
  }
}
