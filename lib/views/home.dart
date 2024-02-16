// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:project1/views/confirm.dart';

class homeUI extends StatefulWidget {
  @override
  _homeUIState createState() => _homeUIState();
}

class _homeUIState extends State<homeUI> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เลือกวันที่ต้องการจอง'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Check-In Date: ${_checkInDate != null ? _formatDateTime(_checkInDate!) : "Not selected"}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDateTime(context, true),
            ),
            ListTile(
              title: Text('Check-Out Date: ${_checkOutDate != null ? _formatDateTime(_checkOutDate!) : "Not selected"}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDateTime(context, false),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width*0.1,
            ),
            ElevatedButton(
              onPressed: ()  {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmUI(
                      checkInDate: _checkInDate,
                      checkOutDate: _checkOutDate,

                    ),
                    
                  )
                );
                
              } ,
              child: Text('ยืนยันการจอง'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context, bool isCheckIn) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025, 12, 31),
    );

    if (selectedDate != null) {
      setState(() {
        if(isCheckIn){
          _checkInDate = selectedDate;
        }else{
          _checkOutDate = selectedDate;
        }

      });

     

       
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.toLocal().day}/${dateTime.toLocal().month}/${dateTime.toLocal().year} ';
  }
}
