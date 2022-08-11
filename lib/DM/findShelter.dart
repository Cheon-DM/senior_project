import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';

import 'package:provider/provider.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import 'package:flutter/material.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../HS/mainpage.dart';
import '../Provider/LocateData.dart';
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

class aroundShelter extends StatefulWidget {
  @override
  State<aroundShelter> createState() => _aroundShelterState();
}

class _aroundShelterState extends State<aroundShelter> {
  late WebViewController _mapController;
  late LocateProvider _locateProvider = Provider.of<LocateProvider>(context, listen: false);
  bool _isLoading = true; // 로딩중

  List<Map<String, dynamic>> around1 = []; // 1km 근방
  List<Map<String, dynamic>> around2 = []; // 2km 근방
  late String jsonAround1;
  late String jsonAround2;


  Future<void> readExcelFile() async {
    List<Map<String, dynamic>> around1KM = [];
    List<Map<String, dynamic>> around2KM = [];

    WidgetsFlutterBinding.ensureInitialized();
    ByteData data = await rootBundle.load("assets/EQ_Shelter.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    int j=0;
    Map<int, List<dynamic>> mp = Map<int, List<dynamic>>(); // 대피소 저장 리스트

    num min_dis = 100000;
    var min_index = 0;

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        List<dynamic> tmp = [];
        tmp.add(row[5]!.props.first); // 대피소
        tmp.add(row[9]!.props.first); // 경도
        tmp.add(row[10]!.props.first); // 위도
        mp[j] = tmp;
        j++;
      }
    }
    _locateProvider.locateMe(); // 내 위치

    int a = 0; // 1km list
    int b = 0; // 2km list

    for(int i = 1; i< mp.length; i++){
      // lat : 위도, lng : 경도
      double lat2 = mp[i]![2]; // 위도
      double lng2 = mp[i]![1]; // 경도
      String spot = mp[i]![0]; // 장소이름

      num distance = calculate(context.read<LocateProvider>().my_lat, lat2, context.read<LocateProvider>().my_lng, lng2); // 거리 계산

      if (min_dis > distance){
        min_dis = distance;
        min_index = i;
      }

      if (distance <= 1){
        Map<String, dynamic> tmp = {
          'spot': spot as String,
          'lat': lat2,
          'lng': lng2,
        };
        around1KM.add(tmp);
        a++;
      }

      if(distance > 1 && distance <= 2){
        Map<String, dynamic> tmp = {
          'spot': spot,
          'lat': lat2,
          'lng': lng2,
        };
        around2KM.add(tmp);
        b++;
      }
    }

    setState(() {
      //refresh the UI -> 가장 가까운 대피소 찍기
      //_locateProvider.lat_change(mp[min_index]![2]);
      //_locateProvider.lng_change(mp[min_index]![1]);
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
    Timer(Duration(seconds: 15), () {
      _isLoading = false;
      print(_isLoading); // 지도 뜨게 함.
    });
  }

  Stream<Future<dynamic>> locate() async* {
    Timer(Duration(seconds: 20), () {
      _locateProvider.locateMe();
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
          FutureBuilder(
              future: readExcelFile(),
              builder: (context, snap) {
                return StreamBuilder(
                    stream: locate(),
                    builder: (context, snapshot) {
                      if (_isLoading){
                        print('loading');
                        return const CircularProgressIndicator();
                      }
                      else {
                        print('loading done');
                        return KakaoMapView(
                            width: size.width,
                            height: 400,
                            kakaoMapKey: kakaoMapKey,
                            showMapTypeControl: true,
                            showZoomControl: true,
                            lat: context.read<LocateProvider>().my_lat,
                            lng: context.read<LocateProvider>().my_lng,
                            customScript: '''
    var markers = [];
    var imageURL = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png';
    
    var objAround1 = ${jsonAround2};
    
    var jsonObjKey = [];
    var jsonObjSpot = []; //jsonObj value 'spot' 담을 배열
    var jsonObjLat = []; //jsonObj value 'lat' 담을 배열
    var jsonObjLng = []; //jsonObj value 'lng' 담을 배열
    for(var i=0; i<objAround1.length; i++){
      jsonObjSpot.push(objAround1[i][Object.keys(objAround1[i])[0]]); // spot만 담음      
      jsonObjLat.push(objAround1[i][Object.keys(objAround1[i])[1]]); // lat만 담음      
      jsonObjLng.push(objAround1[i][Object.keys(objAround1[i])[2]]); // lng만 담음
    };   

    function addMarker(position, image) {

      var marker = new kakao.maps.Marker({position: position, image: image});

      marker.setMap(map);

      markers.push(marker);
    }
    
    function createMarkerImage(src, size, options) {
      var markerImage = new kakao.maps.MarkerImage(src, size, options);
      return markerImage;            
    }
    
    var imageSize = new kakao.maps.Size(200, 100);
    var imageOptions = {  
                spriteOrigin: new kakao.maps.Point(0, 0),    
                spriteSize: new kakao.maps.Size(20, 50)  
            };
    var markerImage = createMarkerImage(imageURL, imageSize, imageOptions);

    for(let i = 0 ; i < jsonObjSpot.length ; i++){
      addMarker(new kakao.maps.LatLng(jsonObjLat[i], jsonObjLng[i]), markerImage);
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
      addMarker(new kakao.maps.LatLng(${context.read<LocateProvider>().my_lat} + 0.0003, ${context.read<LocateProvider>().my_lng} + 0.0003));
      
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
        showMapTypeControl: true,
        showZoomControl: true,
        lat: context.read<LocateProvider>().my_lat,
        lng: context.read<LocateProvider>().my_lng,
        customScript: '''
    var markers = [];
    console.log('..');
       
    let data = $around1['0']; // 리스트 값 가져오기
    let obj = JSON.parse(data); // 객체
    let result = JSON.stringify(data); // 문자열
    
    // var leng = $around1.length;

    console.log(data);
    console.log(obj['0']);
    console.log(result);
    
    function addMarker(position) {
    
      var marker = new kakao.maps.Marker({position: position});

      marker.setMap(map);
    
      markers.push(marker);
    }
    
    for(let i = 0 ; i < 3 ; i++){
      
      addMarker(new kakao.maps.LatLng(result[i][0], result[i][1]));
      //console.log('lat: ', + result[i][0]);
      //console.log('lng: ', + result[i][1]);

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

