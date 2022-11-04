import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import 'package:flutter/material.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../mainpage.dart';
import '../provider/ReadShelterData.dart';
import '../provider/LocateData.dart';
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
  return dis;
}

class AroundShelter extends StatefulWidget {
  @override
  State<AroundShelter> createState() => _AroundShelterState();
}

class _AroundShelterState extends State<AroundShelter> {
  late WebViewController _mapController;
  late LocateProvider _locateProvider = Provider.of<LocateProvider>(context, listen: false);
  late ShelterProvider _shelterProvider = Provider.of<ShelterProvider>(context);
  bool _isLoading = true; // 로딩중

  List<Map<String, dynamic>> around1 = []; // 1km 근방
  List<Map<String, dynamic>> around2 = []; // 2km 근방
  late String jsonAround1;
  late String jsonAround2;
  double min_lat = 0;
  double min_lng = 0;
  String min_spot = "";

  Future<void> readExcelFile() async {
    List<Map<String, dynamic>> around1KM = [];
    List<Map<String, dynamic>> around2KM = [];
    int j=0;
    num min_dis = 100000;

    var min_index = 0;

    _locateProvider.friendLocation(); //친구위치
    _locateProvider.locateMe(); // 내 위치
    _shelterProvider.readShelterdata(); // 파일 읽기
    Map<int, List<dynamic>> mp = context.read<ShelterProvider>().mp; // 대피소 저장 리스트

    int a = 0; // 1km list
    int b = 0; // 2km list

    for(int i = 1; i< mp.length; i++){
      // lat : 위도, lng : 경도
      double lat2 = mp[i]![1]; // 위도
      double lng2 = mp[i]![0]; // 경도
      String spot = mp[i]![2]; // 장소이름

      num distance = calculate(context.read<LocateProvider>().my_lat, lat2, context.read<LocateProvider>().my_lng, lng2); // 거리 계산

      if (min_dis > distance){
        min_dis = distance;
        min_index = i;
        min_lat = lat2;
        min_lng = lng2;
        min_spot = spot;
      }

      if (distance <= 1){
        Map<String, dynamic> tmp = {
          'spot': spot as String,
          'lat': lat2 as double,
          'lng': lng2 as double,
        };
        around1KM.add(tmp);
        a++;
      }

      if(distance > 1 && distance <= 2){
        Map<String, dynamic> tmp = {
          'spot': spot as String,
          'lat': lat2,
          'lng': lng2,
        };
        around2KM.add(tmp);
        b++;
      }
    }

    setState(() {
      //refresh the UI -> 가장 가까운 대피소 찍기
      around1 = around1KM;
      around2 = around2KM;
      jsonAround1 = jsonEncode(around1);
      jsonAround2 = jsonEncode(around2);
    });

  }

  @override
  void initState(){
    super.initState();
    _locateProvider.locateMe();
    readExcelFile();

    Timer(Duration(seconds: 10), () {
      _isLoading = false;
    });
  }

  Stream<Future<dynamic>> locate() async* {
    Timer(Duration(seconds: 40), () {
      readExcelFile();
      _locateProvider.locateMe();
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
          FutureBuilder(
              future: readExcelFile(),
              builder: (context, snap) {
                return StreamBuilder(
                    stream: locate(),
                    builder: (context, snapshot) {
                      if (_isLoading){
                        return const CircularProgressIndicator();
                      }
                      else {
                        return KakaoMapView(
                            width: size.width,
                            height: 600,
                            kakaoMapKey: kakaoMapKey,
                            showMapTypeControl: true,
                            showZoomControl: true,
                            lat: context.read<LocateProvider>().my_lat,
                            lng: context.read<LocateProvider>().my_lng,
                            mapController: (controller) {
                              _mapController = controller;
                            },
                            zoomLevel: 2,
                            customScript: '''
    var markers = [];
    var imageURL = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png';    
    var objAround1 = ${jsonAround1};
        
    var jsonObjKey = [];
    var jsonObjSpot = []; //jsonObj value 'spot' 담을 배열
    var jsonObjLat = []; //jsonObj value 'lat' 담을 배열
    var jsonObjLng = []; //jsonObj value 'lng' 담을 배열
    for(var i=0; i<objAround1.length; i++){
      jsonObjSpot.push(objAround1[i][Object.keys(objAround1[i])[0]]); // spot만 담음      
      jsonObjLat.push(objAround1[i][Object.keys(objAround1[i])[1]]); // lat만 담음      
      jsonObjLng.push(objAround1[i][Object.keys(objAround1[i])[2]]); // lng만 담음
    };   

    function addMarker(marker) {
      marker.setMap(map);
      markers.push(marker);
    }

    function createMarkerImage(src, size, options) {
      var markerImage = new kakao.maps.MarkerImage(src, size, options);
      return markerImage;            
    }
    
    function clickMarker(marker, iwContent, iwRemoveable) {
      var infowindow = new kakao.maps.InfoWindow({
        content : iwContent,
        removable : iwRemoveable
      });
      
      kakao.maps.event.addListener(marker, 'click', function() {
        infowindow.open(map, marker);
      });
    }
    var imageSize = new kakao.maps.Size(30, 40);
    var imageOptions = {  
                spriteOrigin: new kakao.maps.Point(0, 0),    
                spriteSize: new kakao.maps.Size(30, 40)  
            };
    var markerImage = createMarkerImage(imageURL, imageSize, imageOptions);
    
    var customStyle = document.createElement("style");
    document.head.appendChild(customStyle);
    
    customStyle.sheet.insertRule(".customoverlay {position:relative;bottom:85px;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd;float:left;}", 0);
    customStyle.sheet.insertRule(".customoverlay:nth-of-type(n) {border:0; box-shadow:0px 1px 2px #888;}");
    customStyle.sheet.insertRule(".customoverlay a {display:block;text-decoration:none;color:#000;text-align:center;border-radius:6px;font-size:14px;font-weight:bold;overflow:hidden;background: #d95050;background: #d95050 url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/arrow_white.png) no-repeat right 14px center;}");
    customStyle.sheet.insertRule(".customoverlay .title {display:block;text-align:center;background:#fff;margin-right:35px;padding:10px 15px;font-size:14px;font-weight:bold;}");
    customStyle.sheet.insertRule(".customoverlay:after {content:'';position:absolute;margin-left:-12px;left:50%;bottom:-12px;width:22px;height:12px;background:url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png');}");
    
    
    for(let i = 0 ; i < jsonObjSpot.length ; i++){
      var marker = new kakao.maps.Marker({position: new kakao.maps.LatLng(jsonObjLat[i], jsonObjLng[i]), image: markerImage, clickable: true});
      var iwContent = '<div class="customoverlay">' + '<span class="title">' + jsonObjSpot[i] + '</span>' + '</div>';
      addMarker(marker);
      clickMarker(marker, iwContent, true);
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
                );
              }
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  _mapController.runJavascript(
                      'map.setLevel(map.getLevel() + 1, {animate: true})');
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
                      'map.setLevel(map.getLevel() - 1, {animate: true})');
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
    var imageURL = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png';
    var markerImage = createMarkerImage(imageURL, imageSize, imageOptions);
    var objAround1 = ${jsonAround2};
    
    var jsonObjKey = new Array();
    var jsonObjSpot = new Array(); //jsonObj value 'spot' 담을 배열
    var jsonObjLat = new Array(); //jsonObj value 'lat' 담을 배열
    var jsonObjLng = new Array(); //jsonObj value 'lng' 담을 배열
    for(var i=0; i<objAround1.length; i++){
      jsonObjSpot.push(objAround1[i][Object.keys(objAround1[i])[0]]); // spot만 담음      
      jsonObjLat.push(objAround1[i][Object.keys(objAround1[i])[1]]); // lat만 담음      
      jsonObjLng.push(objAround1[i][Object.keys(objAround1[i])[2]]); // lng만 담음
    };

    for(let i = 0 ; i < jsonObjSpot.length ; i++){
      var marker = new kakao.maps.Marker({position: new kakao.maps.LatLng(jsonObjLat[i], jsonObjLng[i]), image: markerImage, clickable: true});
      addMarker(marker, markerImage);
      clickMarker(marker, jsonObjSpot[i], true);
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

                  _locateProvider.locateMe();
                  await _mapController.clearCache();
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

    /// This is short form of the above comment
    String url =
    await util.getMapScreenURL(min_lat, min_lng, name: min_spot);
    String testURL1 = "https://map.kakao.com/link/to/" + min_spot + "," + min_lat.toString() + "," + min_lng.toString() + "/from/내 위치," + context.read<LocateProvider>().my_lat.toString() + "," + context.read<LocateProvider>().my_lng.toString() ;

    print('url : $url');

    Navigator.push(
        context, MaterialPageRoute(builder: (_) => KakaoMapScreen(url: testURL1))
    );
  }
}

