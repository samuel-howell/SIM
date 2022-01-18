import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:howell_capstone/src/screens/nav-drawer-screen.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:howell_capstone/src/widgets/custom-alert-dialogs.dart';
import 'package:howell_capstone/theme/custom-colors.dart';

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

class StoreScreen extends StatefulWidget {
  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  Stream<QuerySnapshot> streamQuery = db
      .collection('Users')
      .doc(Database().getCurrentUserID().toString())
      .collection('stores')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
        appBar: AppBar(
            title: Text('MY STORES'),
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
                                child: ListTile(
                                    tileColor: tappedIndex == index
                                        ? Colors.green[400]
                                        : null, // if the tappedIndex is the index of the list tile, adda  green accent to it, otherwise do nothing
                                    title: Text(
                                      doc.get('name'),
                                      style: TextStyle(
                                        fontSize: 20,
                                      ) ),
                                    subtitle: Text(doc.get('address'),
                                      style: TextStyle(
                                          fontSize: 15,
                                        )),
                                    onTap: () {
                                      Database.setcurrentStoreID(doc.id);
                                      Database().setStoreClicked(
                                          true); // now the user can access item screen.

                                      setState(() {
                                        tappedIndex =
                                            index; //by changing the index of this list tile to the tapped index, we know to put a green accent around only this list tile
                                      });
                                      

                                      //print out to console what the current store id, index, and list length and tapped index is.
                                      print('the getCurrentStoreID is ' +
                                          Database().getCurrentStoreID());
                                      print('the current user id is ' +
                                          _auth.currentUser!.uid.toString());
                                      print(
                                          'item index  is ' + index.toString());
                                      print('list length  is ' +
                                          snapshot.data!.docs.length
                                              .toString());
                                      print('tapped index is ' +
                                          tappedIndex.toString());
                                      print(" ");
                                    }),
                                actions: <Widget>[
                                  // NOTE: using "secondaryActions" as opposed to "actions" allows us to slide in from the right instead of the left"

                                  // slide action to delete
                                  IconSlideAction(
                                      caption: 'Delete',
                                      color: Colors.red,
                                      icon: Icons.delete_sharp,
                                      onTap: () => {
                                            showStoreDeleteConfirmationAlertDialog(
                                                context, doc.id),
                                            print('store ' +
                                                doc.id +
                                                ' was deleted.')
                                          }),

                                  // slide action to edit
                                  IconSlideAction(
                                      caption: 'Edit',
                                      color: CustomColors.red,
                                      icon: Icons.edit,
                                      onTap: () => {
                                            showEditStoreDialog(
                                                context, doc.id),
                                            print('store ' +
                                                doc.id +
                                                ' was edited')
                                          }),
                                ]);
                          }))
                ]));
              }
            }),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.post_add),
          onPressed: () => {
            showAddStoreDialog(context),
          },
        ));
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

              //  this stream query matches the searchkey to the names of the stores in the db
              streamQuery = db
                  .collection('Users')
                  .doc(currentUserID)
                  .collection('stores')
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

                //  this stream query matches the searchkey to the names of the stores in the db
                streamQuery = db
                    .collection('Users')
                    .doc(currentUserID)
                    .collection('stores')
                    .where('lowercaseName', isGreaterThanOrEqualTo: searchKey)
                    .where('lowercaseName', isLessThan: searchKey + 'z')
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
}
