
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

              RepaintBoundary(
                key: key,
                child: Container(
                  color:Colors.white,
                  child: QrImage(
                    data: qrTextController.text,
                    size: 200,
                    backgroundColor: Colors.white,
                    ),
                ),
              ),

              SizedBox(height:40),
              buildTextField(context),
              buildExportQRBtn(context, qr, key, file),
              
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
    hintText: 'Enter the item ID ',
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
      onPressed: () => setState(() {
        qr = qrTextController.text; // set qr to the text from the field so we can validate it
      }),
    )
  )
);
}


Widget buildExportQRBtn(BuildContext context, String qr, GlobalKey key, File? file) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 25.0),
    child: Column(
        children: 
          [
            SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Color(0xFF73AEF5)),
                          child: Text('Export QR to other services'),
                          
                          onPressed: () async {

                           
                           //TODO figure out a way to download it to device locally.  See todo below
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

                              //current time
                              var datetime = DateTime.now();
                              //qr image file creation
                              file = await File('${localAppDir!.path}/$datetime.jpg').create();                  

                              //appending data
                              await file?.writeAsBytes(pngBytes);


print("application documents directory is " + appDir.path.toString());
print("external storage directory is " + localAppDir.path.toString());



                              //Shares QR image
                              await Share.shareFiles(
                                [file!.path],
                                mimeTypes: ["image/png"],
                                text: "Share the QR Code",
                              );
                            } catch (e) 
                            {
                              print(e.toString());                
                            }              
                  }
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Color(0xFF73AEF5)),
                          child: Text('Download QR'),
                          
                          onPressed: () async {

                            createFolder("capstonefolderrrr");    //!  this error is thrown ERROR:flutter/lib/ui/ui_dart_state.cc(209)] Unhandled Exception: FileSystemException: Creation failed, path = 'storage/emulated/0/capstonefolderrrr' (OS Error: Operation not permitted, errno = 1)

                          }
            )
          )
        ],

    ),
  );  
  }
 


void _showFilesinDir({required Directory dir}) {
    dir.list(recursive: false, followLinks: false)
    .listen((FileSystemEntity entity) {
      print(entity.path);
    });
  }


//TODO:  integregrate the code below  following this link - https://referbruv.com/blog/posts/capturing-app-view-and-writing-to-local-storage-in-flutter
// Future<String> _captureImage() async {
//     RenderRepaintBoundary boundary =
//         _boundaryKey.currentContext.findRenderObject();
//     var image = await boundary.toImage();

//     // get the directory to write the file
//     var directory = await getExternalStorageDirectory();

//     // prepare the file path
//     var filePath =
//         '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';

//     // extract bytes from the image
//     ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
//     Uint8List pngBytes = byteData.buffer.asUint8List();

//     // openwrite a File with the specified path
//     File imgFile = new File(filePath);

//     // write the image bytes to the file
//     imgFile.writeAsBytes(pngBytes);

//     // return the created file
//     return filePath;
//   }

// for downloading qr code on the web
//  Future<void> downloadImage(String imageUrl) async {
//     try {
//       // first we make a request to the url like you did
//       // in the android and ios version
//       final http.Response r = await http.get(
//         Uri.parse(imageUrl),
//       );
      
//       // we get the bytes from the body
//       final data = r.bodyBytes;
//       // and encode them to base64
//       final base64data = base64Encode(data);
      
//       // then we create and AnchorElement with the html package
//       final a = html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');
      
//       // set the name of the file we want the image to get
//       // downloaded to
//       a.download = 'download.jpg';
      
//       // and we click the AnchorElement which downloads the image
//       a.click();
//       // finally we remove the AnchorElement
//       a.remove();
//     } catch (e) {
//       print(e);
//     }
//   }


//  method to create a new folder on the local device
  Future<String> createFolder(String folder) async {
  final folderName = folder;
  final path = Directory("storage/emulated/0/$folderName");
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  if ((await path.exists())) {
    return path.path;
  } else {
    path.create();
    return path.path;
  }
}

//  perhaps use this package for reading the qr codes - https://pub.dev/packages/flutter_barcode_scanner

//TODO:  See if you can integrate this https://codereis.com/posts/multi-image-pdf/ onto this page.  take the qr, turn it into an image, multiply that image x number of times on a pdf page.