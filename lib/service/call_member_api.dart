import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:project1/model/member.dart';
import 'package:project1/util/env.dart';


class CallMemberAPI {
//สร้างเมธอดเรียกใช้ API : Login
  static Future<Member> LoginAPI(Member member) async {
    //เรียกใช้ API
    final responseData = await http.post(
        Uri.parse(Uri.decodeFull(Env.apiURL + '/login_api.php')),
        body: json.encode(member.toJson()),
        headers: {"Content-type": "application/json"});

    //นำผลที่ได้จากการเรียกใช้ API ไปใช้งาน
    if (responseData.statusCode == 200) {

      //นำข้อมูลที่ได้จากการเรียกใช้ API ซึ่งเป็น Json มาแปลงเป็ฯข้อมูลเพื่อใช้ในแอพ
      final data = await json.decode(responseData.body);   

      return Member.fromJson(data);
    }else{
      throw Exception('Fail: ${responseData.toString()}');
    }
  }
}
