import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;




class ConfirmUI extends StatefulWidget {
  final DateTime? checkInDate;
  final DateTime? checkOutDate;

  ConfirmUI({
    required this.checkInDate,
    required this.checkOutDate,
  });

  @override
  _ConfirmUIState createState() => _ConfirmUIState();
}

class _ConfirmUIState extends State<ConfirmUI> {
  String generateQR = '';

  @override
  void initState() {
    super.initState();
    fetchPaymentData();
  }

  Future<void> fetchPaymentData() async {
    final response =
        await http.post(Uri.parse('http://100.101.72.24:3000/generateQR'));

    if (response.statusCode == 200) {
      setState(() {
        generateQR = response.body;
      });
    } else {
      throw Exception('Failed to load payment data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ยืนยันการจอง'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQrCode(context),
                Text('Check-In Date: ${_formatDateTime(widget.checkInDate)}'),
                Text('Check-Out Date: ${_formatDateTime(widget.checkOutDate)}'),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCode(BuildContext context) {
    return QrImageView(
      data: generateQR,
      version: QrVersions.auto,
      
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    return dateTime != null
        ? '${dateTime.toLocal().day}/${dateTime.toLocal().month}/${dateTime.toLocal().year} ${dateTime.toLocal().hour}:${dateTime.toLocal().minute}'
        : 'Not selected';
  }
}
