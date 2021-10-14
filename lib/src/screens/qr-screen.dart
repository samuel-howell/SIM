import 'dart:js';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScreen extends StatefulWidget {

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final qrTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Screen'),
        centerTitle: true,
        backgroundColor: Colors.black
      ),

      body: Center(
        child: SingleChildScrollView(
          padding:EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              QrImage(
                data: qrTextController.text,
                size: 200,
                backgroundColor: Colors.white,
                ),
              SizedBox(height:40),
              buildTextField(context),
               
            ]
          )
        )
      )
    );
  }

Widget buildTextField(BuildContext context) => TextField(
  controller: qrTextController,
  style: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 20
  ),

  decoration: InputDecoration(
    hintText: 'Enter the item ID you want stored on the QR code',
    hintStyle: TextStyle(color: Colors.grey),
    enabledBorder:OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: Theme.of(context).accentColor,
        ),
    ),
    suffixIcon: IconButton(
      color: Theme.of(context).accentColor,
      icon: Icon(Icons.done, size: 30),
      onPressed: () => setState(() {}),
    )
  )
);
}

//https://youtu.be/hHehIGfX_yU

//  perhaps use this package for reading the qr codes - https://pub.dev/packages/flutter_barcode_scanner