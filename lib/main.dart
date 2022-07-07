import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/HS/landingpage.dart';
import 'package:senior_project/HW/addFriend.dart';
import 'DM/Auth.dart';
import 'DM/findShelter.dart';
import 'DM/message.dart';
import 'HS/mainpage.dart';


void main() async {

  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  authFirebase();
  runApp(MaterialApp(
      home: AddFriend()));
}
