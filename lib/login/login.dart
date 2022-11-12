import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../provider/LocateData.dart';
import 'signup.dart';
import '../info/myPage.dart';

class LogIn extends StatefulWidget {
  static String routeName = "/login";

  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  final ref = FirebaseFirestore.instance.collection('user');
  late LocateProvider _locateProvider =
  Provider.of<LocateProvider>(context, listen: false);

  String userName = '';
  String userEmail = '';
  String userPassword = '';

  void _tryValidation() {
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      _formkey.currentState!.save();
    }
  }
  //
  // Future<UserCredential> signInWithGoogle() async {
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  //   DocumentSnapshot documentSnapshot =
  //       await ref.doc(googleUser!.id).get();
  //   if (!documentSnapshot.exists) {
  //     final userName = await Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => GoogleSignUp()));
  //     ref.doc(googleUser!.id).set({
  //       'userName': userName,
  //       'email': userEmail,
  //       'uid': googleUser!.id,
  //       'userPhotoUrl': null,
  //       'my_lat': 0,
  //       'my_lng': 0
  //     });
  //     documentSnapshot = await ref.doc(googleUser.id).get();
  //   }
  //
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //키보드 밀려올라감 방지
      resizeToAvoidBottomInset: false,

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
            Navigator.of(context, rootNavigator: true).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 70, right: 70),

        child: Form(
          key: _formkey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,

            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  key: ValueKey(5),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '이메일 주소를 입력해주세요';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userEmail = value!;
                  },
                  onChanged: (value) {
                    userEmail = value!;
                  },

                  cursorWidth: 1.5,
                  cursorRadius: Radius.circular(5),
                  cursorColor: Color(0xff6157DE),
                  style: TextStyle(
                    fontFamily: 'Leferi',
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    icon: Icon(
                        Icons.person,
                    ),
                    hintText: ' Email',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xff6157DE),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xff6157DE),
                          width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  ),
                ),
              ),

              SizedBox(height: 10),

              TextFormField(
                key: ValueKey(6),
                validator: (value) {
                  if (value!.isEmpty) {
                    return '비밀번호를 입력해주세요';
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
                    hintText: ' Password',

                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xff6157DE),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xff6157DE),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                cursorWidth: 1.5,
                cursorRadius: Radius.circular(5),
                cursorColor: Color(0xff6157DE),
                obscureText: true,
              ),
              SizedBox(height: 50),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SignUp();
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
            _locateProvider.locateMe();
            _tryValidation();

            try {
              final newUser = await _authentication.signInWithEmailAndPassword(
                  email: userEmail, password: userPassword);
              if (newUser.user == null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('제대로된 입력 필요')));
              }

              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MyPage();
              }));

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('로그인 완료.')));
            } catch (e) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('아이디, 비밀번호를 확인해주세요')));
              print(e);
            }
          },
          child: Container(
            padding: EdgeInsets.only(top: 9),
            height: 50,
            color: const Color(0xff6157DE),
            child: Text(
              '로그인',
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
