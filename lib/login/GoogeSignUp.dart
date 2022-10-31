import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';

class GoogleSignUp extends StatefulWidget {
  @override
  _GoogleSignUpState createState() => _GoogleSignUpState();
}

class _GoogleSignUpState extends State<GoogleSignUp> {
  final _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String userName = '';

  void _tryValidation() {
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      _formkey.currentState!.save();

      Timer(Duration(seconds: 4), () {
        Navigator.pop(context, userName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xff6157DE),
        elevation: 0,
        title: Text(
          "GoogleUser 정보입력",
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
              return LogIn();
            }));
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(height: 50),
                //사용자 이름 박스
                TextFormField(
                  cursorColor: const Color(0xff6157DE),
                  key: ValueKey(1),
                  //닉네임 키: 1
                  validator: (value) {
                    //value 는 사용자가 입력한것 인자값
                    if (value!.isEmpty) {
                      return '사용할 닉네임을 입력해주세요';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userName = value!;
                  },
                  onChanged: (value) {
                    userName = value!;
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    icon: Icon(Icons.accessibility),
                    labelText: "사용자 이름",
                    labelStyle: TextStyle(
                      color: const Color(0xff6157DE),
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                    hintText: '닉네임',
                    border: OutlineInputBorder(),

                    //입력 활성화 중 UI
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide(
                            width: 1, color: const Color(0xff6157DE))),

                    //입력 비활성화 중 UI
                    filled: true,
                    fillColor: Colors.grey[100],
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide(
                            width: 1, color: const Color(0xff6157DE))),
                  ),
                ),
                Container(height: 10),

                //아이디 박스
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () async {
            _tryValidation();
          },
          child: Container(
            padding: EdgeInsets.only(top: 9),
            height: 50,
            color: const Color(0xff6157DE),
            child: Text(
              'Google 계정으로 회원가입하기',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Leferi',
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey;
              } else {
                return Color(0xff6157de);
              }
            }),
          ),
        ),
      ),
    );
  }
}
