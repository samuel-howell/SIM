import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';



//accesses the firebase database
final db = FirebaseFirestore.instance;


List<List<String>> storeList = [
      <String>["STORE", "ADDRESS"]];

class SIMPLExport {

  Future<Directory> getDir() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  generateStoreCsv() async {

    await addMyStoreDocs(); // adds all stores that user has created to export list
    await addSharedStoreDocs(); // adds all stores that have been shared with to export list



// method to generate a csv file containing all stores and save it to downloads folder
    print("GENERATE STORE CSV WAS CLICKED");
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MM-dd-yyyy-HH-mm-ss').format(now);
    String csvData = ListToCsvConverter().convert(storeList);

      // how to download on web 
          if (kIsWeb) {
            print('registering as a web device');
            final bytes = utf8.encode(csvData);
      //NOTE THAT HERE WE USED HTML PACKAGE
            final blob = html.Blob([bytes]);
      //It will create downloadable object
            final url = html.Url.createObjectUrlFromBlob(blob);
      //It will create anchor to download the file
            final anchor = html.document.createElement('a') as html.AnchorElement
              ..href = url
              ..style.display = 'none'
              ..download = 'SIMPL_S-EXPORT_$formattedDate.csv';
      //finally add the csv anchor to body
            html.document.body!.children.add(anchor);
      // Cause download by calling this function
            anchor.click();//revoke the object
            html.Url.revokeObjectUrl(url);

            print(storeList.toString());
          print('made it to the end of web export. resetting storelist now...');

          // reset store list to just store and address header
           storeList = [<String>["STORE", "ADDRESS"]];

          print(storeList.toString());
          }

          


      else if (Platform.isAndroid) {
          Directory generalDownloadDir = Directory('/storage/emulated/0/Download');


          final File file = await File(
                  '${generalDownloadDir.path}/SIMPL_S-EXPORT_$formattedDate.csv')
              .create(); //! you cant have spaces in the file name or you will get errno = 1
          await file.writeAsString(csvData);

          print(storeList.toString());
          print('made it to the end of android export. resetting storelist now...');

          // reset store list to just store and address header
           storeList = [<String>["STORE", "ADDRESS"]];

          print(storeList.toString());
        }

         
    }


//todo: HOW WE GET FIRESTORE DATA WITHOUT USING LISTVIEW OR ANYTHING ELSE!!!!!!
//! THIS FILE IS HOW WE GET FIREBASE DATA WITHOUT HAVING TO BUILD A LISTVIEW OR ANY UI ELEMENT
  Future addMyStoreDocs() async {
  QuerySnapshot querySnapshot = await db.collection('Stores').where('createdBy', isEqualTo: Database().getCurrentUserID().toString()).get();
  for (int i = 0; i < querySnapshot.docs.length; i++) {
    var doc = querySnapshot.docs[i];
    print(doc.get('name'));

    storeList.add(<String>[doc.get('name'), doc.get('address')]);
  }
}

  Future addSharedStoreDocs() async {
  QuerySnapshot querySnapshot = await db.collection('Stores').where('sharedWith', arrayContains: Database().getCurrentUserID().toString()).get(); // only shows stores that have been sharedWith the currently signed in user.
  for (int i = 0; i < querySnapshot.docs.length; i++) {
    var doc = querySnapshot.docs[i];
    print(doc.get('name'));

    storeList.add(<String>[doc.get('name'), doc.get('address')]);
  }
}
}





