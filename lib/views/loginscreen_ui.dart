import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project1/model/member.dart';
import 'package:project1/service/call_member_api.dart';
import 'package:project1/views/homescreen_ui.dart';
import 'package:project1/views/register.dart';

class loginscreen_ui extends StatefulWidget {
  const loginscreen_ui({Key? key}) : super(key: key);

  @override
  State<loginscreen_ui> createState() => _loginscreen_uiState();
}

class _loginscreen_uiState extends State<loginscreen_ui> {
  TextEditingController memUsernameCtrl = TextEditingController(text: '');
  TextEditingController memPasswordCtrl = TextEditingController(text: '');

  showWarningDialog(context, masg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'คำเตือน',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        content: Text(
          masg,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  //สร้าง  Object ที่เก็บค่า Username/Passwordที่จะส่งไปกับ API
  Member? member;

  //สร้างเมธอดเพื่อเรียกใช้ API ตรวจสอบ Username/Password
  Future<Member> checklogin() {
    print(member!.memUsername!);
    return CallMemberAPI.LoginAPI(member!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Text(
                'เข้าสู่ระบบ',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: memUsernameCtrl,
                  decoration: InputDecoration(
                    labelText: 'ชื่อผู้ใช้',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: memPasswordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'รหัสผ่าน',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () {
                  if (memUsernameCtrl.text.isEmpty) {
                    showWarningDialog(context, 'โปรดป้อนชื่อผู้ใช้');
                  } else if (memPasswordCtrl.text.isEmpty) {
                    showWarningDialog(context, 'โปรดป้อนรหัสผ่าน');
                  } else {
                    member = Member(
                      memUsername: memUsernameCtrl.text.trim(),
                      memPassword: memPasswordCtrl.text.trim(),
                    );

                    checklogin().then((value) {
                      print(value.message);
                      if (value.message == '1') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreenUI(member: value),
                          ),
                        );
                      } else {
                        showWarningDialog(context, 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง');
                      }
                    }).catchError((error) {
                      showWarningDialog(context, 'เกิดข้อผิดพลาดในการเชื่อมต่อ');
                    });
                  }
                },
                child: Text('เข้าสู่ระบบ'),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text('สมัครสมาชิก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
