import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';
import 'dart:ui';
import 'package:screenshot/screenshot.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart'; // for sharing qr on ios and android

class QRScreen extends StatefulWidget {
  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final key = GlobalKey();
  final qrTextController = TextEditingController();
  String qr = "";
  File? file;
  final screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('QR Screen'),
            centerTitle: true,
            backgroundColor: Colors.black),
        body: Center(
            child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RepaintBoundary(
                        key: key,
                        child: Container(
                          color: Colors.white,
                          child: QrImage(
                            data: qrTextController.text,
                            size: 200,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      buildTextField(context),
                      buildExportQRBtn(context, qr, key, file),
                    ]))));
  }

  Widget buildTextField(BuildContext context) => TextField(
      controller: qrTextController,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      decoration: InputDecoration(
          hintText: 'Enter the item ID ',
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).accentColor,
            ),
          ),
          suffixIcon: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.done, size: 30),
            onPressed: () => setState(() {
              qr = qrTextController
                  .text; // set qr to the text from the field so we can validate it
            }),
          )));

  Widget buildExportQRBtn(
      BuildContext context, String qr, GlobalKey key, File? file) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: Column(
        children: [
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xFF73AEF5)),
                  child: Text('Download QR'),
                  onPressed: () async {
                    //this code "wraps" the qr widget into an image format
                    RenderRepaintBoundary boundary = key.currentContext!
                        .findRenderObject() as RenderRepaintBoundary;
                    //captures qr image
                    var image = await boundary.toImage();

                    String qrName = qrTextController.text;

                    //running on web
                    if (kIsWeb) {
                      print('registering as a web device');
                      ByteData? byteData =
                          await image.toByteData(format: ImageByteFormat.png);
                      Uint8List pngBytes = byteData!.buffer.asUint8List();
                      final _base64 = base64Encode(pngBytes);
                      final anchor = html.AnchorElement(
                          href: 'data:application/octet-stream;base64,$_base64')
                        ..download = "$qrName.png"
                        ..target = 'blank';

                      html.document.body!.append(anchor);
                      anchor.click();
                      anchor.remove();
                    }

                    //running on Android
                    else if (Platform.isAndroid) {
                      print('registering as an android device.');
                      ByteData? byteData =
                          await image.toByteData(format: ImageByteFormat.png);
                      Uint8List pngBytes = byteData!.buffer.asUint8List();

                      //general downloads folder (accessible by files app) ANDROID ONLY
                      Directory generalDownloadDir = Directory(
                          '/storage/emulated/0/Download'); //! THIS WORKS for android only !!!!!! Concerning iOS, from emarco comment  - https://stackoverflow.com/questions/51776109/how-to-get-the-absolute-path-to-the-download-folder/69150584#69150584

                      //qr image file saved to general downloads folder
                      File qrJpg =
                          await File('${generalDownloadDir.path}/$qrName.jpg')
                              .create();
                      await qrJpg.writeAsBytes(pngBytes);

                      Fluttertoast.showToast(
                          msg: ' $qrName QR code was downloaded to ' +
                              generalDownloadDir.path.toString(),
                          gravity: ToastGravity.TOP);
                    }

                    //running on iOS
                    else if (Platform.isIOS) {
                      //TODO: do ios version of download to device method shown above for android and web
                    }
                  })),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Color(0xFF73AEF5)),
                child: Text('Share'),
                onPressed: () async {
                  try {
                    //this code "wraps" the qr widget into an image format
                    RenderRepaintBoundary boundary = key.currentContext!
                        .findRenderObject() as RenderRepaintBoundary;
                    //captures qr image
                    var image = await boundary.toImage();

                    ByteData? byteData =
                        await image.toByteData(format: ImageByteFormat.png);
                    Uint8List pngBytes = byteData!.buffer.asUint8List();

                    //app directory for storing images.
                    final appDir = await getApplicationDocumentsDirectory();
                    final localAppDir = await getExternalStorageDirectory();

                    //qr image file creation
                    file =
                        await File('${localAppDir!.path}/qrcode.jpg').create();

                    //appending data
                    await file?.writeAsBytes(pngBytes);

                    //Shares QR image
                    await Share.shareFiles(
                      [file!.path],
                      mimeTypes: ["image/png"],
                      text: "Share the QR Code",
                    );
                  } catch (e) {
                    print(e.toString());
                  }
                }),
          ),
        ],
      ),
    );
  }
}

//TODO:  See if you can integrate this https://codereis.com/posts/multi-image-pdf/ onto this page.  take the qr, turn it into an image, multiply that image x number of times on a pdf page.
