import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/login/signup_complete.dart';

import 'login.dart';
import '../provider/LocateData.dart';

class signup extends StatefulWidget {
  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {

  final _formkey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;

  String userName = '';
  String userEmail = '';
  String userPassword = '';
  String checkPassword='';

  var ch=0;

  void _tryValidation() {
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      _formkey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xff6157DE),
        elevation: 0,
        title: Text(
          "회원가입",
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
              return login();
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
                TextFormField(
                  cursorColor: const Color(0xff6157DE),

                  key: ValueKey(2),
                  //아이디 키: 2
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return '올바른 이메일 주소를 입력해주세요';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userEmail = value!;
                  },
                  onChanged: (value) {
                    userEmail = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: "아이디",
                    labelStyle: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),

                    hintText: 'Email',
                    border: OutlineInputBorder(),

                    //입력 활성화 중 UI
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide(
                            width: 1, color: const Color(0xff6157DE))),

                    //입력 비활성화 중 UI
                    filled: true,
                    fillColor: Colors.grey[200],
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide(
                            width: 1, color: Color.fromRGBO(0, 0, 0, 0.0))),
                  ),
                ),
                Container(height: 10),

                //비밀번호 박스
                TextFormField(
                  cursorColor: const Color(0xff6157DE),

                  obscureText: true,
                  key: ValueKey(3),
                  //비밀번호 키: 3
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return '비밀번호는 6글자 이상이어야 합니다';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userPassword = value!;
                  },
                  onChanged: (value) {
                    userPassword = value!;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key),
                    labelText: "비밀번호",
                    labelStyle: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),

                    hintText: 'Password',
                    border: OutlineInputBorder(),

                    //입력 활성화 중 UI
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide(
                            width: 1, color: const Color(0xff6157DE))),

                    //입력 비활성화 중 UI
                    filled: true,
                    fillColor: Colors.grey[200],
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide(
                            width: 1, color: Color.fromRGBO(0, 0, 0, 0.0))),
                  ),
                ),
                Container(height: 10),



                //비밀번호 확인 박스
                TextFormField(
                  cursorColor: const Color(0xff6157DE),

                  obscureText: true,
                  key: ValueKey(4),
                  //비밀번호 확인 키: 4
                  validator: (value) {
                    checkPassword != value;
                    if (value != userPassword) {
                      ch=1;
                      return '비밀번호가 일치하지 않습니다';

                    } else if (value!.isEmpty) {
                      return '비밀번호를 입력해주세요';
                    }
                    else{
                      ch=0;return null;
                    }

                  },

                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key_outlined),
                    labelText: "비밀번호 확인",
                    labelStyle: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),

                    hintText: 'Password',
                    border: OutlineInputBorder(),

                    //입력 활성화 중 UI
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide(
                            width: 1, color: const Color(0xff6157DE))),

                    //입력 비활성화 중 UI
                    filled: true,
                    fillColor: Colors.grey[200],
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        borderSide: BorderSide(
                            width: 1, color: Color.fromRGBO(0, 0, 0, 0.0))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () async {
            _tryValidation();
            var newUser;
            if(ch==0) {
              newUser =
              await _authentication.createUserWithEmailAndPassword(
                  email: userEmail, password: userPassword);


              ////////////////////////////////////////////////////////////////////////////////

              late LocateProvider _locateProvider = Provider.of<LocateProvider>(context,listen: false);

              _locateProvider.locateMe();
              await FirebaseFirestore.instance.collection('user').doc(newUser.user!.uid)
                  .set({
                'userName' : userName,
                'email' : userEmail,
                'uid': newUser.user!.uid,
                'userPhotoUrl': null,
                'my_lat': context.read<LocateProvider>().my_lat,
                'my_lng': context.read<LocateProvider>().my_lng

              });
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return signup_complete(userName);
              }));
              //_locateProvider.locateMe();
            }
            else{
              ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('제대로된 입력 필요')));
            }
          },

          child: Container(
            padding: EdgeInsets.only(top: 9),
            height: 50,
            color: const Color(0xff6157DE),
            child: Text(
              '회원가입하기',
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

