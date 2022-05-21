import 'package:flutter/material.dart';
import 'DM/Auth.dart';
import 'HS/mainpage.dart';

void main() async {
  authFirebase();
  runApp(MaterialApp(
      home: MainPage()));
}
