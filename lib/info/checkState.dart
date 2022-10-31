import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'myPage.dart';
import '../login/login.dart';

class CheckState extends StatelessWidget {
  const CheckState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> user) {
          if (user.data == null) {
            return LogIn();
          } else {
            return MyPage();
          }
        });
  }
}