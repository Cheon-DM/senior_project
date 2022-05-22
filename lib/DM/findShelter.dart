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
  final R = 6371e3;
  final _lat1 = radians(lat1);
  final _lat2 = radians(lat2);
  final lat_dif = radians(lat2-lat1);
  final lng_dif = radians(lng2-lng1);

  final a = sin(lat_dif/2) * sin(lat_dif/2) + cos(_lat1) * cos(_lat2) * sin(lng_dif/2) * sin(lng_dif/2);
  final c = 2 * atan2(sqrt(a), sqrt(1-a));


  final answer = c * R;
  return answer / 1000;
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
        tmp.add(row[9]!.props.first);
        tmp.add(row[10]!.props.first);
        mp[j] = tmp;
        print(tmp);

        j++;
      }
    }

    _locateMe();

    for(int i = 1; i< mp.length; i++){
      // lat : 위도, lng : 경도
      double lat2 = mp[i]![2];
      double lng2 = mp[i]![1];
      if (min_dis > calculate(my_lat, lat2, my_lng, lng2)){
        min_dis = calculate(my_lat, lat2, my_lng, lng2);
        min_index = i;
      }
    }

    print(min_dis);
    print(min_index);

    lat = mp[min_index]![2];
    lng = mp[min_index]![1];
    print(mp[min_index]![2]);
    print(mp[min_index]![1]);

    setState(() {
      //refresh the UI
    });

  }

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
    print(position.longitude);
    print(position.latitude);

    my_lat = position.longitude;
    my_lng = position.latitude;

    setState(() {
      //refresh UI
    });
  }

  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        print(_isLoading);
      });
    });
    _locateMe();
    readExcelFile();
  }

  Stream<Future<dynamic>> locate() async* {
    readExcelFile();
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
                    child: KakaoMapView(
                      width: size.width,
                      height: 400,
                      kakaoMapKey: kakaoMapKey,
                      lat: lat,
                      lng: lng,
                      showMapTypeControl: true,
                      showZoomControl: true,
                      draggableMarker: true,
                      mapType: MapType.BICYCLE,
                      mapController: (controller) {
                        _mapController = controller;
                      },
                      polyline: KakaoFigure(
                        path: [
                          KakaoLatLng(
                              lat: 33.45080604081833, lng: 126.56900858718982),
                          KakaoLatLng(
                              lat: 33.450766588506054, lng: 126.57263147947938),
                          KakaoLatLng(
                              lat: 33.45162008091554, lng: 126.5713226693152)
                        ],
                        strokeColor: Colors.blue,
                        strokeWeight: 2.5,
                        strokeColorOpacity: 0.9,
                      ),
                      polygon: KakaoFigure(
                        path: [
                          KakaoLatLng(
                              lat: 33.45086654081833, lng: 126.56906858718982),
                          KakaoLatLng(
                              lat: 33.45010890948828, lng: 126.56898629127468),
                          KakaoLatLng(
                              lat: 33.44979857909499, lng: 126.57049357211622),
                          KakaoLatLng(
                              lat: 33.450137483918496, lng: 126.57202991943016),
                          KakaoLatLng(
                              lat: 33.450706188506054, lng: 126.57223147947938),
                          KakaoLatLng(
                              lat: 33.45164068091554, lng: 126.5713126693152)
                        ],
                        polygonColor: Colors.red,
                        polygonColorOpacity: 0.3,
                        strokeColor: Colors.deepOrange,
                        strokeWeight: 2.5,
                        strokeColorOpacity: 0.9,
                        strokeStyle: StrokeStyle.shortdashdot,
                      ),
                      customOverlayStyle: '''<style>
                                .customoverlay {position:relative;bottom:85px;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd;float:left;}
.customoverlay:nth-of-type(n) {border:0; box-shadow:0px 1px 2px #888;}
.customoverlay a {display:block;text-decoration:none;color:#000;text-align:center;border-radius:6px;font-size:14px;font-weight:bold;overflow:hidden;background: #d95050;background: #d95050 url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/arrow_white.png) no-repeat right 14px center;}
.customoverlay .title {display:block;text-align:center;background:#fff;margin-right:35px;padding:10px 15px;font-size:14px;font-weight:bold;}
.customoverlay:after {content:'';position:absolute;margin-left:-12px;left:50%;bottom:-12px;width:22px;height:12px;background:url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png')}
                                </style>''',
                      customOverlay: '''
const content = '<div class="customoverlay">' +
    '  <a href="https://map.kakao.com/link/map/11394059" target="_blank">' +
    '    <span class="title">현재 위치!</span>' +
    '  </a>' +
    '</div>';

const position = new kakao.maps.LatLng(${my_lat}, ${my_lng});

const customOverlay = new kakao.maps.CustomOverlay({
    map: map,
    position: position,
    content: content,
    yAnchor: 1
});
                                ''',
                      markerImageURL:
                      'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
                      onTapMarker: (message) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message.message)));
                      },
                      zoomChanged: (message) {
                        debugPrint('[zoom] ${message.message}');
                      },
                      cameraIdle: (message) {
                        KakaoLatLng latLng =
                        KakaoLatLng.fromJson(jsonDecode(message.message));
                        debugPrint('[idle] ${latLng.lat}, ${latLng.lng}');
                      },
                      boundaryUpdate: (message) {
                        KakaoBoundary boundary =
                        KakaoBoundary.fromJson(jsonDecode(message.message));
                        debugPrint(
                            '[boundary] ne : ${boundary.neLat}, ${boundary.neLng}, sw : ${boundary.swLat}, ${boundary.swLng}');
                      },
                    ),
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
        lat: 33.450701,
        lng: 126.570667,
        customScript: '''
    let markers = [];
    
    function addMarker(position) {
    
      let marker = new kakao.maps.Marker({position: position});

      marker.setMap(map);
    
      markers.push(marker);
    }
    
    for(let i = 0 ; i < 3 ; i++){
      addMarker(new kakao.maps.LatLng(33.450701 + 0.0003 * i, 126.570667 + 0.0003 * i));

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
