import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/views/paymentscreen.dart';
import 'package:mysql1/mysql1.dart'; // นำเข้าแพ็กเกจที่ใช้ในการเข้าถึงฐานข้อมูล MySQL

class SuiteRoomUI extends StatefulWidget {
  final String roomType;
  final int userId; // เพิ่มตัวแปร userId เพื่อรับค่า memId

  const SuiteRoomUI({Key? key, required this.roomType, required this.userId}) : super(key: key);

  @override
  _SuiteRoomUIState createState() => _SuiteRoomUIState();
}

class _SuiteRoomUIState extends State<SuiteRoomUI> {
  late String selectedRoomType;

  @override
  void initState() {
    super.initState();
    selectedRoomType = widget.roomType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('จองห้องพัก'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(
                selectedRoomType,
                style: GoogleFonts.kanit(
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 8,
                  bottom: 48,
                ),
                child: Image.asset('assets/images/suite.jpg'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedRoomType.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreenUI(
                            roomType: selectedRoomType, userId: widget.userId), // ส่ง userId ไปยัง PaymentScreenUI
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('คำเตือน'),
                          content:
                              Text('กรุณาเลือกประเภทห้องก่อนที่จะดำเนินการต่อ'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('ยืนยันการจอง'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



