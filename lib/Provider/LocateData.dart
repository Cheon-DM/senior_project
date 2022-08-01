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
        /*setState(() {
          //refresh the UI
        });*/
        notifyListeners();
        getLocation();
      }
    }
    else{
      print("GPS Service is not enabled, turn on GPS location");
    }


    /*setState(() {
      //refresh the UI
    });*/
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition();
    print(position.latitude);
    print(position.longitude);

    _my_lat = position.latitude;
    _my_lng = position.longitude;


    notifyListeners();


   /* setState(() {
      //refresh UI
    });*/
  }

  void lat_change(double lat_ch) {
    _lat =lat_ch;
    notifyListeners();
  }

  void lng_change(double lng_ch) {
    _lng =lng_ch;
    notifyListeners();
  }

  /*set lat_change(double lat_ch){
    _lat =lat_ch;
    // notifyListeners();
  }*/
}