import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

class GuideHTTP {
  final String serviceKey = 'yoSJ384pthej3NXwL5MttpP8%2FNOoNFAov7nWzBppOC7CGW%2F%2FuuVjkeqUuU2z8agn4TkZWDYXqbDYUL7DWu8pFg%3D%3D';

  void callAPI() async {
    print('호출됐습니다~~1');

    final url = Uri.parse('http://http://openapi.safekorea.go.kr/openapi/service/behaviorconductKnowHow/naturaldisaster/list?safety_cate=01001&serviceKey=$serviceKey');
    print('호출됐습니다~~2');

    print('시작합니다~~3');
    final response = await http.get(url);
    print('호출됐습니다~~3');

    final Xml2JsonData = Xml2Json()..parse(response.body); //xml->json 변환
    print('호출됐습니다~~4');

    final jsonData = Xml2JsonData.toParker();
    print('호출됐습니다~~5');
    print(jsonData);
    print('${jsonData}');
  }
}
