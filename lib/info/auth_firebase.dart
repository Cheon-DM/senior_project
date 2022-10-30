import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void authFirebase() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAs4QaED_5xj6hvFySG8RhqqvJAMk05gKY",
      appId: "1:1051877983471:android:70919ed3a8496500f6871a",
      messagingSenderId: "1051877983471",
      projectId: "testing-7e550",
    ),
  );
}