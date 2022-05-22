import 'package:flutter/material.dart';
import 'package:senior_project/HS/landingpage.dart';
import 'DM/Auth.dart';
import 'DM/findShelter.dart';
import 'DM/message.dart';
import 'HS/mainpage.dart';

void main() async {
  authFirebase();
  runApp(MaterialApp(
      home: MainPage()));
}
