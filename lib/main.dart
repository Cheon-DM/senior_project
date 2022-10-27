import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/DM/signup.dart';
import 'package:senior_project/Provider/ReadShelterData.dart';
import 'DM/Auth.dart';
import 'HS/mainpage.dart';
import 'Provider/DisasterMsg.dart';
import 'Provider/GuideData.dart';
import 'Provider/LocateData.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  authFirebase();
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_)=>LocateProvider()),
            ChangeNotifierProvider(create: (_)=>DisasterMsgProvider()),
            ChangeNotifierProvider(create: (_)=>ShelterProvider()),
            ChangeNotifierProvider(create: (_)=>GuideDataProvider()),
          ],
          child: MaterialApp(
            home: signup()
          )
      )
  );
}


