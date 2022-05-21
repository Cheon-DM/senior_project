import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../HS/myPage.dart';
import 'login.dart';

class checkState extends StatelessWidget {
  const checkState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> user) {
          if (user.data == null) {
            return login();
          } else {
            return MyPage();
          }
        });
  }
}