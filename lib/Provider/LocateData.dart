import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocateProvider extends ChangeNotifier{

  double _my_lat = 0;
  double _my_lng = 0;
  double _lat = 0;
  double _lng = 0;
  late Position position;
  bool _serviceEnabled = false;
  late LocationPermission _permissionGranted;
  bool haspermission = false;

  double get my_lat => _my_lat;
  double get my_lng => _my_lng;
  double get lat => _lat;
  double get lng => _lng;

  final user =FirebaseAuth.instance.currentUser;
  final ref = FirebaseFirestore.instance.collection('user');

  locateMe() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(_serviceEnabled){
      _permissionGranted = await Geolocator.checkPermission();

      if (_permissionGranted == LocationPermission.denied) {
        _permissionGranted = await Geolocator.requestPermission();
        if (_permissionGranted == LocationPermission.denied) {
          print('Location permissions are denied');
        }
        else if(_permissionGranted == LocationPermission.deniedForever){
          print("'Location permissions are permanently denied");
        }
        else{
          haspermission = true;
        }
      }
      else{
        haspermission = true;
      }

      if(haspermission){
        notifyListeners();
        getLocation();
      }
    }
    else{
      print("GPS Service is not enabled, turn on GPS location");
    }
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition();

    double tmp1 = position.latitude;
    double tmp2 = position.longitude;

    if (_my_lat != tmp1 || _my_lng != tmp2){
      print("change location");
      print(position.latitude);
      print(position.longitude);

      _my_lat = position.latitude;
      _my_lng = position.longitude;

      await ref.doc(user!.uid)
          .update({
        'my_lat': _my_lat,
        'my_lng': _my_lng
      });
      QuerySnapshot querySnapshot = await ref.doc(user!.uid)
          .collection('FriendAdmin').get();

      // Get data from docs and convert map to List
      // final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      final allData = querySnapshot.docs.map((doc) => doc.get('uid')).toList();
      //for a specific field

      print('나와라ㅏ와라');
      print(allData);

      for(var s in allData){
        print(s);
        await FirebaseFirestore.instance.collection('user').doc(s)
            .collection('FriendAdmin').doc(user!.uid).update({
          'friend_lat': tmp1,
          'friend_lng': tmp2,
        });
        print('왜 안되지.....');
      }
    }

    notifyListeners();
  }
}