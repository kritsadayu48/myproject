import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Payment QR Code'),
        ),
        body: Center(
          child: QrImageView(
            data: 'Your Payment Data Here',
            version: QrVersions.auto,
            size: 200.0,
          ),
        ),
      ),
    );
  }
}
