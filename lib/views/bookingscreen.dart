import 'package:flutter/material.dart';

class BookingScreenUI extends StatefulWidget {
  const BookingScreenUI({Key? key}) : super(key: key);

  @override
  State<BookingScreenUI> createState() => _BookingScreenUIState();
}

class _BookingScreenUIState extends State<BookingScreenUI> {
  String? selectedRoomType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('จองห้องพัก'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: selectedRoomType,
              hint: Text('เลือกประเภทห้อง'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedRoomType = newValue;
                });
              },
              items: <String>['Standard', 'Deluxe', 'Suite']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedRoomType != null) {
                  // ทำการจองห้องพัก
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('ยืนยันการจอง'),
                        content: Text('คุณได้ทำการจองห้อง $selectedRoomType แล้ว'),
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
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('คำเตือน'),
                        content: Text('กรุณาเลือกประเภทห้องก่อนที่จะดำเนินการต่อ'),
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
    );
  }
}
