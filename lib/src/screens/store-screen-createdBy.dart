import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:howell_capstone/src/screens/nav-drawer-screen.dart';
import 'package:howell_capstone/src/screens/store-screen-sharedWith.dart';
import 'package:howell_capstone/src/utilities/SIMPL-export.dart';
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

class StoreScreenCreatedBy extends StatefulWidget {
  @override
  State<StoreScreenCreatedBy> createState() => _StoreScreenCreatedByState();
}

class _StoreScreenCreatedByState extends State<StoreScreenCreatedBy> {
  Stream<QuerySnapshot> streamQueryCreatedBy = db.collection('Stores').where('createdBy', isEqualTo: Database().getCurrentUserID().toString())
                  .where('lowercaseName', isGreaterThanOrEqualTo: searchKey) //these 2 wheres organize the stream alphabetically
                  .where('lowercaseName', isLessThan: searchKey + 'z')
                  .snapshots(); // only shows stores that have been created by  the currently signed in user.

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
 
      body: StreamBuilder<QuerySnapshot>(
          stream: streamQueryCreatedBy,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                  child: Column(children: <Widget>[
                //this search bar filters out stores
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: showSearchDialog(),
                ),
      
                Expanded(
                    // if I don't have Expanded here, the listview won't be sized in relation to hte searchbar textfield, thus throwing errors
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];
      
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
                                  onTap: () {
                                    Database.setcurrentStoreID(doc.id);
                                    Database().setStoreClicked(
                                        true); // now the user can access item screen.
      
                                    setState(() {
                                      tappedIndex = index;
                                    }); //by changing the index of this list tile to the tapped index, we know to put a green accent around only this list tile
                                  }),
                              actions: <Widget>[
                                // NOTE: using "secondaryActions" as opposed to "actions" allows us to slide in from the right instead of the left"
      
                                // slide action to delete
                                IconSlideAction(
                                    caption: 'Delete',
                                    color: Theme.of(context).primaryColor,
                                    icon: Icons.delete_sharp,
                                    onTap: () => {
                                          showStoreDeleteConfirmationAlertDialog(
                                              context, doc.id),
                                          print('store ' +
                                              doc.id +
                                              ' was deleted.')
                                        }),
      
                                // slide action to give new user access to the store
                                IconSlideAction(
                                    caption: 'Add User',
                                    color: Theme.of(context).primaryColor,
                                    icon: Icons.person_add,
                                    onTap: () => {
                                          showAddUserDialog(context, doc.id),
                                          print('store ' +
                                              doc.id +
                                              ' was deleted.')
                                        }),
      
                                // slide action to edit
                                IconSlideAction(
                                    caption: 'Edit',
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    icon: Icons.edit,
                                    onTap: () => {
                                          showEditStoreDialog(context, doc.id),
                                          print(
                                              'store ' + doc.id + ' was edited')
                                        }),
                              ]);
                        }))
              ]));
            }
          }),
    );
  }

  showSearchDialog() {
    switch (searchFilter) {
      case 1:
        {
          return showNameSearch();
        }
      case 2:
        {
          return showAddressSearch();
        }
    }
  }

  showchangeSearchDialog(BuildContext context) {
    //
    // set up the buttons
    Widget nameButton = TextButton(
      child: Text("By Name"),
      onPressed: () {
        setState(() {
          return showNameSearch();
        });
        print('New searching by name');
        searchFilter = 1;
        Navigator.of(context).pop(); // removes the dialog from the screen
      },
    );
    Widget addressButton = TextButton(
      child: Text("By Address"),
      onPressed: () {
        setState(() {
          return showAddressSearch();
        });
        print('Now searching by address.');
        searchFilter = 2;
        Navigator.of(context).pop(); // removes the dialog from the screen
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Choose Filter Type"),
      content: Text("Which identifier would you like to search for?"),
      actions: [
        nameButton,
        addressButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

//  the search bar for the stores address
  showAddressSearch() {
    String? currentUserID = _auth.currentUser?.uid;

    return Row(children: <Widget>[
      Expanded(
        // textfield has no intrinsic width, so i have to wrap it in expanded to force it to fill up only the space not occupied by the textbutton in the row.  otherwise, this entire row causes a crash
        child: TextField(
          onChanged: (value) {
            setState(() {
              searchKey = value.toLowerCase();


              streamQueryCreatedBy = db 
                  .collection('Stores').where('createdBy', isEqualTo: Database().getCurrentUserID().toString())
                  .where('lowercaseAddress', isGreaterThanOrEqualTo: searchKey)
                  .where('lowercaseAddress', isLessThan: searchKey + 'z')
                  .snapshots();
            });
          },
          decoration: InputDecoration(
              labelText: "Address Search",
              hintText: "Address Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder()),
        ),
      ),
      TextButton(
          onPressed: () {
            showchangeSearchDialog(context);
          },
          child: Icon(Icons.filter_alt_sharp))
    ]);
  }

// the seach bar for the store name
  showNameSearch() {
    String? currentUserID = _auth.currentUser?.uid;

    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchKey = value.toLowerCase();


                streamQueryCreatedBy = db
                    .collection('Stores')
                    .where('lowercaseName', isGreaterThanOrEqualTo: searchKey)
                    .where('lowercaseName', isLessThan: searchKey + 'z')
                    .where('createdBy', isEqualTo: currentUserID)
                    .snapshots();
              });
            },
            decoration: InputDecoration(
                labelText: "Name Search",
                hintText: "Name Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder()),
          ),
        ),
        TextButton(
            onPressed: () {
              showchangeSearchDialog(context);
            },
            child: Icon(Icons.filter_alt_sharp))
      ],
    );
  }

  Future<Directory> getDir() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory;
  }

// method to generate a csv file containing all stores and save it to downloads folder
  generateCsv() async {
    print("GENERATE CSV WAS CLICKED");
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MM-dd-yyyy-HH-mm-ss').format(now);

  Stream<QuerySnapshot> streamQuery = db.collection('Stores').where('createdBy', isEqualTo: Database().getCurrentUserID().toString()).snapshots(); // only shows stores that have been created by  the currently signed in user.

    print(await streamQuery.length);

    StreamBuilder<QuerySnapshot>(
        stream: streamQuery,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print("snapshot has no data");
            return Text('NO DATA');
          } else {
            return Expanded(
                // if I don't have Expanded here, the listview won't be sized in relation to hte searchbar textfield, thus throwing errors
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];

                      // add the store to the store list
                      storeList
                          .add(<String>[doc.get('name'), doc.get('address')]);
                      print('contents of storeList are: ');
                      print(storeList.toString());
                      print('');

                      return Text(
                          "Stores were exported to a csv file named \"SIMPL-EXPORT-$formattedDate.csv\" in your Downloads folder!");
                    }));
          }
        });

    String csvData = ListToCsvConverter().convert(storeList);

    Directory generalDownloadDir = Directory('/storage/emulated/0/Download');

    print(generalDownloadDir.toString());

    final File file = await File(
            '${generalDownloadDir.path}/SIMPL-EXPORT-$formattedDate.csv')
        .create(); //! you cant have spaces in the file name or you will get errno = 1
    await file.writeAsString(csvData);
  }
}
