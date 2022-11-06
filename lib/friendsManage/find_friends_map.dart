import 'dart:core';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../mainpage.dart';
import '../provider/LocateData.dart';

const String kakaoMapKey = '9e9e53f5a50038a1fdb31333c3afc1d2';

class FindFriendLocation extends StatefulWidget {
  @override
  State<FindFriendLocation> createState() => _FindFriendLocation();
}

class _FindFriendLocation extends State<FindFriendLocation> {
  late WebViewController _mapController;
  late LocateProvider locateProvider = Provider.of<LocateProvider>(context, listen: false);
  bool isLoading = true; // 로딩중

  @override
  void initState(){
    super.initState();
    locateProvider.locateMe();
    locateProvider.friendLocation(); //친구위치

    Timer(Duration(seconds: 10), () {
      isLoading = false;
      setState(() {

      });
    });
  }

  Stream<dynamic> locate() async* {
     Timer(Duration(seconds: 30), () {
       locateProvider.locateMe();
       locateProvider.friendLocation();
       print("streaming");
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
          "친구 위치 찾기",
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
                      if (isLoading){
                        print("_isLoading = true");
                        return const CircularProgressIndicator();
                      }
                      else {
                        print("_isLoading = false");
                        return KakaoMapView(
                            width: size.width,
                            height: size.height / 2,
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
    var friendImageURL = 'http://t1.daumcdn.net/localimg/localimages/07/2012/img/marker_normal.png';
    
    var flat = ${locateProvider.friend_lat};
    var flng = ${locateProvider.friend_lng};
    var fname = ${locateProvider.friend_name};
    console.log(fname);

    function addFriendMarker(marker, image) {
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
    
    var customStyle = document.createElement("style");
    document.head.appendChild(customStyle);
    customStyle.sheet.insertRule(".fname {text-align : center; width: 100px;box-shadow: 3px 4px 0px 0px #1564ad;	background-color:transparent;	border-radius:6px;	border:1px solid #337bc4;	display:inline-block;	cursor:pointer;	color:#3e3670;	font-family:sans-serif;	font-size:16px;	padding:16px 30px;	text-decoration:none;	text-shadow:0px 1px 0px #528ecc;}");
    customStyle.sheet.insertRule(".fname:hover {background-color:transparent;}");
    customStyle.sheet.insertRule(".fname:active {position:relative;}");
    
    for(let i = 0 ; i < flat.length ; i++){
      var imageSize = new kakao.maps.Size(35, 45);
      var imageOptions = {  
          spriteOrigin: new kakao.maps.Point(0, 0 + i * 50),    
          spriteSize: new kakao.maps.Size(644, 946)  
      };
    
      var friendMarkerImage = createMarkerImage(friendImageURL, imageSize, imageOptions);
      var marker = new kakao.maps.Marker({position: new kakao.maps.LatLng(flat[i], flng[i]), image: friendMarkerImage, clickable: true});
      var iwContent = '<div class="fname">' + fname[i] + '</div>';
      
      addFriendMarker(marker, friendMarkerImage);
      clickMarker(marker, iwContent, true);
    }
    
    var info = document.querySelectorAll('.info');
    console.log(info);
    info.forEach(function(e) {
        var w = e.offsetWidth + 10;
        var ml = w/2;
        e.parentElement.style.top = "82px";
        e.parentElement.style.left = "50%";
        e.parentElement.style.marginLeft = -ml+"px";
        e.parentElement.style.width = w+"px";
        e.parentElement.previousSibling.style.display = "none";
        e.parentElement.parentElement.style.border = "0px";
        e.parentElement.parentElement.style.background = "#65c9be";
    });

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
                onTap: () {},
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
                  locateProvider.locateMe();
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
              onPressed: () {
              })
        ],
      ),
    );
  }
}

