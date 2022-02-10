import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:howell_capstone/src/screens/nav-drawer-screen.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:howell_capstone/src/widgets/custom-alert-dialogs.dart';
import 'package:howell_capstone/theme/custom-colors.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

//  init firesbase auth
final FirebaseAuth _auth = FirebaseAuth.instance;

//accesses the firebase database
final db = FirebaseFirestore.instance;

//hovercolor for web on store list
//final hoverColor = Colors.indigo[50];

//  this var will store the index of the store that is currently highlighted in the Listview.builder
var tappedIndex;

// for the search bar
String searchKey = "";
int searchFilter = 1; //  set to 1, so the default search would be Name Search

List<List<String>> storeList = [];

class StoreScreenExport extends StatefulWidget {
  @override
  State<StoreScreenExport> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreenExport> {
  Stream<QuerySnapshot> streamQuery = db.collection('Stores').snapshots();

  @override
  void initState() {
    super.initState();
    storeList = [
      <String>["STORE", "ADDRESS"]
    ]; // we have to reset storeList  to empty every time the page is built. we add one entry <String>["STORE", "ADDRESS"] to serve as a headers though.
  }

//*  this page just loads all the stores into a list and gives the user an opprotunity to export as csv file
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stores to be Exported'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: streamQuery,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                  child: Column(children: <Widget>[
                Expanded(
                    // if I don't have Expanded here, the listview won't be sized in relation to hte searchbar textfield, thus throwing errors
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];

                          // add the store to the store list
                          storeList.add(
                              <String>[doc.get('name'), doc.get('address')]);
                          print('contents of storeList are: ');
                          print(storeList.toString());
                          print('');

                          // the slideable widget allows us to use slide ios animation to bring up delete and edit dialogs
                          return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      color: tappedIndex == index
                                          ? (Colors.green[400])!
                                          : (Colors.red[200])!,
                                      elevation: 16,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Wrap(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .background,
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10))),
                                            margin: EdgeInsets.only(left: 10),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  doc
                                                      .get('name')
                                                      .toString(), // string pulled in as param
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    doc
                                                        .get('address')
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 18))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {}),
                              actions: <Widget>[
                                // NOTE: using "secondaryActions" as opposed to "actions" allows us to slide in from the right instead of the left"
                              ]);
                        }))
              ]));
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.file_download),
        onPressed: () => {
          generateCsv(),
          Fluttertoast.showToast(msg: 'Store List was exported!'),
          Navigator.pop(context),
        },
      ),
    );
  }

  Future<Directory> getDir() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  generateCsv() async {
// method to generate a csv file containing all stores and save it to downloads folder
    print("GENERATE CSV WAS CLICKED");
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

      print('made it to the end pf web dl');
    }

    


else if (Platform.isAndroid) {
    Directory generalDownloadDir = Directory('/storage/emulated/0/Download');


    final File file = await File(
            '${generalDownloadDir.path}/SIMPL_S-EXPORT_$formattedDate.csv')
        .create(); //! you cant have spaces in the file name or you will get errno = 1
    await file.writeAsString(csvData);

    print('made it to the end');
  }
  }
}
