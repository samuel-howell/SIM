import 'dart:async';
import 'dart:io';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:howell_capstone/src/screens/item-info-screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vibration/vibration.dart';
import 'package:howell_capstone/src/utilities/database.dart';

class ScanScreen extends StatefulWidget {
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  Barcode? result;
  QRViewController? controller;
  DateTime? lastScan;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  int qrRead = 0;
  int scanType = 0;

  // this determines which button turns green on click
  bool isScanOutTapped = false;
  bool isScanInTapped = false;
  bool isTallyCountTapped = false;
  bool isViewTapped = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  // this is the helper method for the popup menu button
  void onSelected(BuildContext context, int item) async {
    switch (item) {
      case 0:
        await controller?.toggleFlash();
        break;

      case 1:
        await controller?.flipCamera();
        break;

      case 2:
        await controller?.pauseCamera();
        break;

      case 3:
        await controller?.resumeCamera();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
                  PopupMenuItem(
                      child: Text('Toggle Flash'),
                      value:
                          0 // this is the value that will be passed when we press on this popup menu item
                      ),
                  PopupMenuItem(child: Text('Flip Camera'), value: 1),
                  PopupMenuItem(child: Text('Pause Camera'), value: 2),
                  PopupMenuItem(child: Text('Resume Camera'), value: 3)
                ])
      ]),
      body: Column(
        children: <Widget>[
          Expanded(flex: 3, child: _buildQrView(context)),
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  else
                    Text('SELECT SCAN TYPE THEN BEGIN SCAN'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex:
                            1, // this flex value gives width priority to whatever widget Expanded is wrapped around.  since all widgets on row are set to 1, they are all equal in width
                        child: Container(
                          margin: EdgeInsets.all(6),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(50, 50),
                                primary: isScanInTapped ? Colors.green : null),
                            child: Text('Scan IN'),
                            onPressed: () async {
                              scanType = 0;
                              setState(() {
                                // depending on which one is selectd, it turns that button color green while wiping the others to default
                                isTallyCountTapped = false;
                                isScanInTapped = true;
                                isScanOutTapped = false;
                                isViewTapped = false;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.all(6),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(50, 50),
                                primary:
                                    isScanOutTapped ? Colors.green[400] : null),
                            child: Text('Scan OUT'),
                            onPressed: () async {
                              scanType =
                                  1; // this scan type determines what database procedure is carried out during the qr code read

                              setState(() {
                                isScanInTapped = false;
                                isScanOutTapped = true;
                                isTallyCountTapped = false;
                                isViewTapped = false;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.all(6),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(50, 50),
                                  primary:
                                      isTallyCountTapped ? Colors.green : null),
                              child: Text('Tally Count'),
                              onPressed: () async {
                                scanType = 2;

                                setState(() {
                                  isTallyCountTapped = true;
                                  isScanInTapped = false;
                                  isScanOutTapped = false;
                                  isViewTapped = false;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.all(6),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(50, 50),
                                  primary: isViewTapped ? Colors.green : null),
                              child: Text('View'),
                              onPressed: () async {
                                scanType = 3;
                                setState(() {
                                  isTallyCountTapped = false;
                                  isScanInTapped = false;
                                  isScanOutTapped = false;
                                  isViewTapped = true;
                                });
                              },
                            ),
                          ),
                        )
                      ])
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
    });

// by using the DateTime below in the if statement, we put a 2 second interval delay between each time the state is set to the new ScanData, this prevents the stream from pushing a bunch of duplicate ScanData while the user hovers on a QR code
    controller.scannedDataStream.listen((scanData) async {
      final currentScan = DateTime.now();
      if (lastScan == null ||
          currentScan.difference(lastScan!) > const Duration(seconds: 2)) {
        lastScan = currentScan;
        qrRead++; // just a tracker to see how quick the scanner is reading codes with the delay in place

        // if device has vibration capabilities, vibrate for 200 ms on successful scan
        if (await Vibration.hasVibrator() != null) {
          Vibration.vibrate(duration: 200);
        } else {
          Fluttertoast.showToast(
              msg: 'QR was successfully scanned!',
              gravity: ToastGravity
                  .TOP); // this is for devices that don't have vibration
        }

        setState(() {
          result = scanData;
          print('the qr just read was ' +
              scanData.code +
              " qr count: " +
              qrRead.toString());

          //  depending on whether scan in, scan out, tally count, or view was selected (represented by scan type), call the appropriate method
          switch (scanType) {
            case 0:
              Database.incrementItemQuantity(scanData.code);
              break;
            case 1:
              Database.decrementItemQuantity(scanData.code);
              break;
            case 2:
              //TODO: Do something for the tally count here...

              /* 
                Do something like this:

                https://pusher.com/tutorials/local-data-flutter/
                Store it locally
                */
              break;
            case 3:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ItemInfoScreen(itemDocID: result!.code)));
          }
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
