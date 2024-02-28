// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:project1/views/bookingscreen.dart';

class PaymentScreenUI extends StatefulWidget {
  final String roomType;
  final int userId;

  const PaymentScreenUI({Key? key, required this.roomType, required this.userId}) : super(key: key);

  @override
  _PaymentScreenUIState createState() => _PaymentScreenUIState();
}

class _PaymentScreenUIState extends State<PaymentScreenUI> {
  File? receiptImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ชำระเงิน'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'คุณเลือกห้อง: ${widget.roomType}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            receiptImage != null
                ? Image.file(
                    receiptImage!,
                    height: MediaQuery.of(context).size.height * 0.3,
                  )
                : Image.asset(
                    'assets/images/payment.jpg',
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _uploadReceipt();
              },
              child: Text('แนบสลิป'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveBookingAndReceipt();
              },
              child: Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveBookingAndReceipt() async {
    if (receiptImage == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('แจ้งเตือน'),
            content: Text('กรุณาเลือกสลิปการชำระเงินก่อน'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('ตกลง'),
              ),
            ],
          );
        },
      );
      return;
    }

    final Map<String, dynamic> data = {
      'roomType': widget.roomType,
    };

    final String jsonData = jsonEncode(data);

    final apiUrl =
        'https://s6319410013.sautechnology.com/loginapi/apis/confirmbook.php';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('สำเร็จ'),
            content: Text('ส่งข้อมูลการจองและสลิปการชำระเงินสำเร็จ'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('ตกลง'),
              ),
            ],
          );
        },
      );
     
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BookingScreenUI(userId: widget.userId)),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('ข้อผิดพลาด'),
            content: Text('เกิดข้อผิดพลาดในการส่งข้อมูล'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('ตกลง'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _uploadReceipt() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        receiptImage = File(pickedImage.path);
      });
    }
  }
}
