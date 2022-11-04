import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'landingpage.dart';
import 'info/auth_firebase.dart';
import 'provider/DisasterMsg.dart';
import 'provider/GuideData.dart';
import 'provider/LocateData.dart';
import 'provider/ReadShelterData.dart';

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
            home: LandingPage()
          )
      )
  );
}


