import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void fetchPost() async {
  var url = Uri.parse("https://www.safekorea.go.kr/idsiSFK/neo/sfk/cs/sfc/dis/disasterMsgList.jsp?menuSeq=679");
  var response = await http.get(url);
  // final http.Response response = await http.get(Uri.parse('https://www.safekorea.go.kr/idsiSFK/neo/sfk/cs/sfc/dis/disasterMsgList.jsp?menuSeq=679'));

  if (response.statusCode == 200) {
    // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
    var responseBody = utf8.decode(response.bodyBytes);
    print('Response body: ${responseBody}');

  }
  else {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

//bbs_th, //boardList_table, //disasterSms_tr //.ellipsis
class Disasterlist {
  final int number;
  final String kind;
  final String level;
  final String message;
  final int date;

  Disasterlist({required this.number, required this.kind, required this.level, required this.message, required this.date});

}
/*class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({required this.userId, required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}*/

class tester extends StatefulWidget {
  tester({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<tester> {
  // late Future<Post> post;

  /*@override
  void initState() {
    super.initState();
    //post = fetchPost();
  }*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(

          ),
        ),
      );
  }
}