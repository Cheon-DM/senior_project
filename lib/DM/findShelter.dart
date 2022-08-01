import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';

import 'package:geolocator/geolocator.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import 'package:flutter/material.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../HS/mainpage.dart';
import 'kakaomap_screen.dart';

const String kakaoMapKey = '9e9e53f5a50038a1fdb31333c3afc1d2';

num calculate(double lat1, double lat2, double lng1, double lng2){
  double dis;
  final R = 6371;

  final deltaLat = radians((lat1-lat2).abs());
  final deltaLng = radians((lng1-lng2).abs());

  final sinDeltaLat = sin(deltaLat/2);
  final sinDeltaLng = sin(deltaLng/2);
  final squareRoot = sqrt(sinDeltaLat * sinDeltaLat + cos(radians(lat1)) * cos(radians(lat2)) * sinDeltaLng * sinDeltaLng);

  dis = 2 * R * asin(squareRoot);
  // final R = 6371e3;
  // final _lat1 = radians(lat1);
  // final _lat2 = radians(lat2);
  // final lat_dif = radians(lat2-lat1);
  // final lng_dif = radians(lng2-lng1);
  //
  // final a = sin(_lat1) * sin(_lat2) + cos(_lat1) * cos(_lat2) * cos(lng_dif);
  // final c = atan(a);
  // final dis = degrees(c) * 60 * 1.1515 * 1.609344;
  //
  return dis;
}

class aroundShelter extends StatefulWidget {
  @override
  State<aroundShelter> createState() => _aroundShelterState();
}

class _aroundShelterState extends State<aroundShelter> {
  late WebViewController _mapController;
  double my_lat = 0;
  double my_lng = 0;
  double lat = 0;
  double lng = 0;
  bool _isLoading = true;
  late Position position;
  bool _serviceEnabled = false;
  late LocationPermission _permissionGranted;
  bool haspermission = false;

  Map<int, List<dynamic>> around1KM = Map<int, List<dynamic>>();
  Map<int, List<dynamic>> around2KM = Map<int, List<dynamic>>();

  Future<void> readExcelFile() async {
    WidgetsFlutterBinding.ensureInitialized();
    ByteData data = await rootBundle.load("assets/EQ_Shelter.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    int j=0;
    Map<int, List<dynamic>> mp = Map<int, List<dynamic>>();


    num min_dis = 100000;
    var min_index = 0;


    for (var table in excel.tables.keys) {
      print(table);

      for (var row in excel.tables[table]!.rows) {
        List<dynamic> tmp = [];
        tmp.add(row[5]!.props.first);
        tmp.add(row[9]!.props.first); // 경도
        tmp.add(row[10]!.props.first); // 위도
        mp[j] = tmp;
        // print(tmp);

        j++;
      }
    }

    _locateMe();
    int a = 0; // 1km list
    int b = 0; // 2km list

    for(int i = 1; i< mp.length; i++){
      // lat : 위도, lng : 경도
      double lat2 = mp[i]![2];
      double lng2 = mp[i]![1];

      num distance = calculate(my_lat, lat2, my_lng, lng2);

      if (min_dis > distance){
        min_dis = distance;
        min_index = i;
      }

      if (distance <= 1){
        List<dynamic> tmp = [];
        tmp.add(lat2);
        tmp.add(lng2);
        around1KM[a] = tmp;
        a++;
      }

      if(distance > 1 && distance <= 2){
        List<dynamic> tmp = [];
        tmp.add(lat2);
        tmp.add(lng2);
        around2KM[b++] = tmp;

      }
    }
    //print(min_index);
    //print(min_dis);
    //print(around1KM[0]![0].runtimeType);

    setState(() {
      //refresh the UI
      lat = mp[min_index]![2];
      lng = mp[min_index]![1];
    });

  }
////////////////////////////////////////////////////////////////////////////////
  _locateMe() async {
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
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    }
    else{
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition();
    print(position.latitude);
    print(position.longitude);

    my_lat = position.latitude;
    my_lng = position.longitude;

    setState(() {
      //refresh UI
    });
  }
////////////////////////////////////////////////////////////////////////////////
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 10), () {
      setState(() {
        _isLoading = false;
        print(_isLoading);
      });
    });
    _locateMe();
    readExcelFile();
  }

  Stream<Future<dynamic>> locate() async* {
    Timer(Duration(seconds: 10), () {

      readExcelFile();
    });
  }

  @override
  void dispose(){
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff6157DE),
        elevation: 5,
        title: Text(
          "내 주변 대피소",
          style: TextStyle(
            fontFamily: 'Leferi',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                  return MainPage();
                }));
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StreamBuilder(
              stream: locate(),
              builder: (context, snapshot) {
                if (_isLoading){
                  print(_isLoading);
                  return const CircularProgressIndicator();
                }
                else {
                  print(_isLoading);
                  return Expanded(
                    child: _testingCustomScript(
                        size: size,
                        context: context,
                    )
                  );
                }
              }
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  _mapController.runJavascript(
                      'map.setLevel(map.getLevel() - 1, {animate: true})');
                },
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _mapController.runJavascript(
                      'map.setLevel(map.getLevel() + 1, {animate: true})');
                },
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  _mapController.runJavascript('''
      addMarker(new kakao.maps.LatLng($my_lat + 0.0003, ${my_lng} + 0.0003));
      
      function addMarker(position) {
        let testMarker = new kakao.maps.Marker({position: position});

        testMarker.setMap(map);
      }
                      ''');
                },
                child: CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: const Icon(
                    Icons.pin_drop,
                    color: Colors.white,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await _mapController.reload();
                  debugPrint('[refresh] done');
                },
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          ElevatedButton(
              child: Text('Kakao map screen'),
              onPressed: () async {
                await _openKakaoMapScreen(context);
              })
        ],
      ),
    );
  }

  Future<void> _openKakaoMapScreen(BuildContext context) async {
    KakaoMapUtil util = KakaoMapUtil();

    // String url = await util.getResolvedLink(
    //     util.getKakaoMapURL(37.402056, 127.108212, name: 'Kakao 본사'));

    /// This is short form of the above comment
    String url =
    await util.getMapScreenURL(37.402056, 127.108212, name: 'Kakao 본사');

    debugPrint('url : $url');

    Navigator.push(
        context, MaterialPageRoute(builder: (_) => KakaoMapScreen(url: url)));

  }



  Widget _testingCustomScript(
      {required Size size, required BuildContext context}) {
    return KakaoMapView(
        width: size.width,
        height: 400,
        kakaoMapKey: kakaoMapKey,
        markerImageURL: 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
        showMapTypeControl: true,
        showZoomControl: true,
        lat: my_lat,
        lng: my_lng,
        customScript: '''
    let markers = [];
       
    let data = ${around1KM};
    
    
    const result = JSON.stringify(data); // string

    for(let i in data) {
  console.log(i); // key
  console.log(data[i][0]); // value against the key
}
   
    
    function addMarker(position) {
    
      let marker = new kakao.maps.Marker({position: position});

      marker.setMap(map);
    
      markers.push(marker);
    }
    
    for(let i = 0 ; i < Object.keys(data).length ; i++){
      addMarker(new kakao.maps.LatLng(data[i][0] + 0.0003 * i, data[i][1] + 0.0003 * i));
      

      kakao.maps.event.addListener(markers[i], 'click', (i) => {
        return function(){
          onTapMarker.postMessage('marker ' + i + ' is tapped');
        };
      });
    }
    
		  const zoomControl = new kakao.maps.ZoomControl();
      map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
   
      const mapTypeControl = new kakao.maps.MapTypeControl();
      map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
              ''',
        onTapMarker: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        });
  }
}
