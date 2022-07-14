import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void update() async {
  DateTime now = DateTime.now();
  DateTime before_1 = DateTime.now().subtract(Duration(days: 1));
  DateTime before_2 = DateTime.now().subtract(Duration(days: 2));
  DateTime before_3 = DateTime.now().subtract(Duration(days: 3));

  DateFormat formatter = DateFormat('yyyy-MM-dd');

  String nowString1 = formatter.format(before_1);
  String pastString1 = formatter.format(before_1);
  String pastString2 = formatter.format(before_2);
  String pastString3 = formatter.format(before_3);

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var ref = firebaseFirestore.collection("disaster_message");
  List<int> deletelist = [];

  ref.get().then((value) {
    for (var doc in value.docs) {
      if (doc['FRST_REGIST_DT'] != nowString1 || doc['FRST_REGIST_DT'] != pastString1 || doc['FRST_REGIST_DT'] != pastString2 || doc['FRST_REGIST_DT'] != pastString3){
        deletelist.add(doc['BBS_ORDR']);
      }
    }
    print(deletelist);
    for (int i = 0; i < deletelist.length ; i++){
      ref.doc('${deletelist[i]}').delete();
    }
  });
}

void crawling() async {
  var url = Uri.parse("http://m.safekorea.go.kr/idsiSFK/neo/ext/json/disasterDataList/disasterDataList.json");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
    var responseBody = utf8.decode(response.bodyBytes);
    // print('Response Body: ${response.body}');
    final List result = jsonDecode(responseBody);
    var item = result[0];
    for (int i = 0; i < result.length; i++){
      item = result[i];

      create(item['BBS_ORDR'], item['CONT'], item['FRST_REGIST_DT']);
    }
  }

  else {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

Future<void> create (int BBS_ORDR, String CONT, String FRST_REGIST_DT) async {
  final item = FirebaseFirestore.instance.collection("disaster_message").doc("${BBS_ORDR}");
  var checking = await item.get();

  // 송출 지역 뽑아내기
  String parsingSentense = CONT;
  final re = RegExp(r'^\[[ㄱ-ㅎ가-힣]+\]');
  String LOCATION = parsingSentense.splitMapJoin(re, onMatch: (m) => '${m[0]}', onNonMatch: (n) => '');
  // print('1: ${LOCATION}');
  String sub = LOCATION.substring(1, 3);
  print('2: ${sub}');
  int areaNum = adminArea(sub);

  if (areaNum == 0){
    String fullLoc = LOCATION.substring(1, LOCATION.length-1);
    switch (fullLoc){
      case '광주광역시':
        areaNum = 5;
        break;
      case '광주시청':
        areaNum = 9;
        break;
      default:
        areaNum = 18;
        break;
    }
  }

  if(checking.exists){ // msg exist
  }
  else { // new msg
    item.set({
      "BBS_ORDR": BBS_ORDR,
      "CONT": CONT,
      "FRST_REGIST_DT": FRST_REGIST_DT,
      "AREA": areaNum,
    });
  }
}

int adminArea(String area){
  int areaNum;

  switch (area){
    case '서울':
    case '종로':
    case '용산':
    case '성동':
    case '광진':
    case '동대':
    case '중랑':
    case '성북':
    case '강북':
    case '도봉':
    case '노원':
    case '은평':
    case '서대':
    case '마포':
    case '양천':
    case '강서':
    case '구로':
    case '금천':
    case '영등':
    case '동작':
    case '관악':
    case '서초':
    case '강남':
    case '송파':
    case '강동':
      areaNum = 1;
      break;
    case '부산':
    case '영도':
    case '동래':
    case '해운':
    case '사하':
    case '금정':
    case '연제':
    case '수영':
    case '사상':
    case '기장':
      areaNum = 2;
      break;
    case '대구':
    case '수성':
    case '달서':
    case '달성':
      areaNum = 3;
      break;
    case '인천':
    case '미추':
    case '연수':
    case '남동':
    case '부평':
    case '계양':
    case '강화':
    case '옹진':
      areaNum = 4;
      break;
    case '광산':
      areaNum = 5;
      break;
    case '대전':
    case '유성':
    case '대덕':
      areaNum = 6;
      break;
    case '울산':
    case '울주':
      areaNum = 7;
      break;
    case '세종':
      areaNum = 8;
      break;
    case '경기':
    case '수원':
    case '성남':
    case '의정':
    case '안양':
    case '부천':
    case '광명':
    case '평택':
    case '동두':
    case '안산':
    case '고양':
    case '과천':
    case '구리':
    case '남양':
    case '오산':
    case '시흥':
    case '군포':
    case '의왕':
    case '하남':
    case '용인':
    case '파주':
    case '이천':
    case '안성':
    case '김포':
    case '화성':
    case '양주':
    case '포천':
    case '여주':
    case '연천':
    case '가평':
    case '양평':
      areaNum = 9;
      break;
    case '강원':
    case '춘천':
    case '원주':
    case '강릉':
    case '동해':
    case '태백':
    case '속초':
    case '삼척':
    case '홍천':
    case '횡성':
    case '영월':
    case '평창':
    case '정선':
    case '철원':
    case '화천':
    case '양구':
    case '인제':
    case '양양':
      areaNum = 10;
      break;
    case '충북':
    case '청주':
    case '충주':
    case '제천':
    case '보은':
    case '옥천':
    case '영동':
    case '증평':
    case '진천':
    case '괴산':
    case '음성':
    case '단양':
      areaNum = 11;
      break;
    case '충남':
    case '천안':
    case '공주':
    case '보령':
    case '아산':
    case '서산':
    case '논산':
    case '계룡':
    case '금산':
    case '부여':
    case '서천':
    case '청양':
    case '홍성':
    case '예산':
    case '태안':
    case '당진':
      areaNum = 12;
      break;
    case '전북':
    case '전주':
    case '군산':
    case '익산':
    case '정읍':
    case '남원':
    case '김제':
    case '완주':
    case '진안':
    case '무주':
    case '장수':
    case '임실':
    case '순창':
    case '고창':
    case '부안':
      areaNum = 13;
      break;
    case '전남':
    case '목포':
    case '여수':
    case '순천':
    case '나주':
    case '광양':
    case '담양':
    case '곡성':
    case '구례':
    case '고흥':
    case '보성':
    case '화순':
    case '장흥':
    case '강진':
    case '해남':
    case '영암':
    case '무안':
    case '함평':
    case '영광':
    case '장성':
    case '완도':
    case '진도':
    case '신안':
      areaNum = 14;
      break;
    case '경북':
    case '포항':
    case '경주':
    case '김천':
    case '안동':
    case '구미':
    case '영주':
    case '영천':
    case '상주':
    case '문경':
    case '경산':
    case '군위':
    case '의성':
    case '청송':
    case '영양':
    case '영덕':
    case '청도':
    case '고령':
    case '성주':
    case '칠곡':
    case '예천':
    case '봉화':
    case '울진':
    case '울릉':
      areaNum = 15;
      break;
    case '경남':
    case '창원':
    case '진주':
    case '통영':
    case '사천':
    case '김해':
    case '밀양':
    case '거제':
    case '양산':
    case '의령':
    case '함안':
    case '창녕':
    case '남해':
    case '하동':
    case '산청':
    case '함양':
    case '거창':
    case '합천':
      areaNum = 16;
      break;
    case '제주':
    case '서귀':
      areaNum = 17;
      break;
    default:
      areaNum = 18;
      break;
  }

  // 고성, 광주, 광역시 등등 처리 필요
  return areaNum;
}

