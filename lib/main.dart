import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/HS/landingpage.dart';
import 'package:senior_project/HW/addFriend.dart';
import 'package:senior_project/HW/demo.dart';
import 'package:senior_project/HW/friendlist.dart';
import 'package:senior_project/HW/login.dart';
import 'DM/Auth.dart';
import 'DM/findShelter.dart';
import 'DM/message.dart';
import 'HS/mainpage.dart';
import 'HW/requestedFriend.dart';
import 'Provider/LocateData.dart';
import 'package:provider/provider.dart';


void main() async {

//  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  authFirebase();
  runApp(
    //home: MainPage())
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_)=>LocateProvider())
      ],child: MaterialApp(
          home:MainPage()))
  );
}


/*void main() async {

//  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  authFirebase();
  runApp(
      MaterialApp(
          home:MainPage())
  );
}*/

