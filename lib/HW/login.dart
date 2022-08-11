import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:senior_project/HS/mainpage.dart';

import '../DM/signup.dart';
import '../HS/myPage.dart';

class login extends StatelessWidget {

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;

  String userName = '';
  String userEmail = '';
  String userPassword = '';

  void _tryValidation() {
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      _formkey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //키보드 밀려올라감 방지
      resizeToAvoidBottomInset : false,

      appBar: AppBar(
        backgroundColor: const Color(0xff6157DE),
        elevation: 5,
        title: Text(
          "로그인",
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
        padding: const EdgeInsets.all(100),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              TextFormField(

                key: ValueKey(5),
                validator: (value) {
                  if (value!.isEmpty) {
                    return '이메일 아이디 입력안됨';
                  }
                  return null;
                },
                onSaved: (value) {
                  userEmail = value!;
                },
                onChanged: (value) {
                  userEmail = value!;
                },

                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Username', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextFormField(
                key: ValueKey(6),
                validator: (value) {
                  if (value!.isEmpty) {
                    return '제발 돼라';
                  }
                  return null;
                },
                onSaved: (value) {
                  userPassword = value!;
                },
                onChanged: (value) {
                  userPassword = value!;
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key),
                    hintText: 'Password', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              Text(
                '아직 회원이 아니신가요?',
                style: TextStyle(
                  fontFamily: 'Leferi',
                  color: Colors.grey[700],
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return signup();
                      }));
                },
                child: Text(
                  "회원가입하기",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontFamily: 'Leferi',
                    color: Colors.grey[700],
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
      bottomNavigationBar: BottomAppBar(
        child: GestureDetector(
          onTap: () async {
            _tryValidation();

            try {
              final newUser = await _authentication
                  .signInWithEmailAndPassword(
                  email: userEmail, password: userPassword);
              if (newUser.user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('제대로된 입력 필요')));
              }

              /*Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return MyPage();
                    }));*/
              Get.offAll(() => MyPage());
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('로그인 완료.')));
            }catch(e){
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('입력잘못')));
              print(e);
            }
          },
          child: Container(
            padding: EdgeInsets.only(top: 9),
            height: 50,
            color: const Color(0xff6157DE),
            child: Text('로그인',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Leferi',
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
          ),
        ),
      ),
    );
  }
}
