import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:howell_capstone/src/res/custom-colors.dart';
import 'package:howell_capstone/src/screens/item-info-screen.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:howell_capstone/src/widgets/custom-alert-dialogs.dart';

import 'add-item-screen.dart';

//  gets the current user id
final FirebaseAuth _auth = FirebaseAuth.instance;

//accesses the firebase database
final db = FirebaseFirestore.instance;

//hovercolor for web on store list
final hoverColor = Colors.indigo[50];

//  this var will store the index of the store that is currently highlighted in the Listview.builder
var tappedIndex;

// for the search bar
String searchKey = "";

double lowSearchKey = 0; // have to be double because prices can be $24.99 etc.
double highSearchKey = 0;


int searchFilter = 1;




class ItemScreen extends StatefulWidget {
  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {


  //String? Database().getCurrentUserID() = _auth.currentUser?.uid;

//declaring stream
  Stream<QuerySnapshot> streamQuery = db
    .collection('Users')
    .doc(Database().getCurrentUserID())
    .collection('stores')
    .doc(Database().getCurrentStoreID()) 
    .collection('items')
    .snapshots(); 



  @override
  Widget build(BuildContext context) {
    


    try {
          return Scaffold(
          appBar: AppBar(
          title: Text('Item Screen'), 
          centerTitle: true,
          backgroundColor: Colors.black),


      body: StreamBuilder<QuerySnapshot>(
          stream: streamQuery, // this streamQuery will change based on what is typed into the search bar
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
    
            else {
              return Container(
                  child: Column(children: <Widget>[
                //this search bar filters out stores
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: showSearchDialog(),
                ),

                Expanded(
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
                                    ? Colors.greenAccent
                                    : null, // if the tappedIndex is the index of the list tile, adda  green accent to it, otherwise do nothing
                                hoverColor:
                                    hoverColor, //  adds some extra pizzazz if you're viewing it on the web
                                title: Text(doc.get('name')),
                                subtitle: Text(doc.get('description')),
                                onTap: () {
                                  //TODO: open a new page and populate it with all item details from firebase

                                  //print out to console what the current store id, index, and list length and tapped index is.
                                  print('the getCurrentStoreID is ' +
                                      Database().getCurrentStoreID());
                                  print('the current user id is ' +
                                      _auth.currentUser!.uid.toString());
                                  print('item index  is ' + index.toString());
                                  print('list length  is ' +
                                      snapshot.data!.docs.length.toString());
                                  print('tapped index is ' +
                                      tappedIndex.toString());

                                  print(" ");

                                  final data = Data(itemDocID: doc.id);

                                  Navigator.push(context,MaterialPageRoute( builder: (context) => ItemInfoScreen(itemDocID: doc.id), // pass the doc id to the item infor screen page
                                  ));
                                }),
                            actions: <Widget>[
                              // NOTE: using "secondaryActions" as opposed to "actions" allows us to slide in from the right instead of the left"

                              // slide action to delete
                              IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.red,
                                  icon: Icons.delete_sharp,
                                  onTap: () => {
                                        showItemDeleteConfirmationAlertDialog(
                                            context, doc.id),
                                        print(
                                            'item ' + doc.id + ' was deleted.')
                                      }),

                              // slide action to edit
                              IconSlideAction(
                                  caption: 'Edit',
                                  color: CustomColors.cblue,
                                  icon: Icons.edit,
                                  onTap: () => {
                                        showEditItemDialog(context, doc.id),
                                        print('item ' + doc.id + ' was edited')
                                      }),
                            ]);
                      }),
                )
              ]));
            }
          }),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.post_add),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () => {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddItemScreen(),
          )) //
        },
      ),
    );
  
    } catch (e) {//! this code isn't working.
      return Center(child: Text('Please choose.'));
    }
  }


  showSearchDialog() {
    switch (searchFilter) {
      case 1:
        {
          return showNameSearch();
        }
      case 2:
        {
          return showItemIDSearch();
        }
      case 3:
        {
          return showPriceSearch();
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
          //* by calling setState there is an immediate change in the textfield whtn the button is pressed.
          return showNameSearch();
        });
        print('New searching by name');
        searchFilter = 1;
        Navigator.of(context).pop(); // removes the dialog from the screen
      },
    );
    Widget addressButton = TextButton(
      child: Text("By Item ID"),
      onPressed: () {
        setState(() {
          return showItemIDSearch();
        });
        print('Now searching by item id.');
        searchFilter = 2;
        Navigator.of(context).pop(); // removes the dialog from the screen
      },
    );
    Widget priceButton = TextButton(
      child: Text("By Price"),
      onPressed: () {
        setState(() {
          return showPriceSearch();
        });
        print('Now searching by price.');
        searchFilter = 3;
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
        priceButton,
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

//  the search bar for the item id
  showItemIDSearch() {
    streamQuery = db
        .collection('Users')
        .doc(Database().getCurrentUserID())
        .collection('stores')
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .snapshots();

    return Row(children: <Widget>[
      Expanded(
        // textfield has no intrinsic width, so i have to wrap it in expanded to force it to fill up only the space not occupied by the textbutton in the row.  otherwise, this entire row causes a crash
        child: TextField(
          onChanged: (value) {
            setState(() {
              searchKey = value;

              //  this stream query matches the searchkey to the names of the stores in the db
              streamQuery = db
                  .collection('Users')
                  .doc(Database().getCurrentUserID())
                  .collection('stores')
                  .doc(Database().getCurrentStoreID())
                  .collection('items')
                  .where('id', isGreaterThanOrEqualTo: searchKey)
                  .where('id', isLessThan: searchKey + 'z')
                  .snapshots();
            });
          },
          decoration: InputDecoration(
              labelText: "Item ID Search",
              hintText: "Item ID Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
        ),
      ),
      TextButton(
          onPressed: () {
            showchangeSearchDialog(context);
          },
          child: Icon(Icons.filter_alt_rounded))
    ]);
  }

// the seach bar for the item name
  showNameSearch() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchKey = value.toLowerCase();

                //  this stream query matches the searchkey to the names of the items in the db
                streamQuery = db
                    .collection('Users')
                    .doc(Database().getCurrentUserID())
                    .collection('stores')
                    .doc(Database().getCurrentStoreID())
                    .collection('items')
                    .where('lowercaseName', isGreaterThanOrEqualTo: searchKey)
                    .where('lowercaseName', isLessThan: searchKey + 'z')
                    .snapshots();
              });
            },
            decoration: InputDecoration(
                labelText: "Name Search",
                hintText: "Name Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
          ),
        ),
        TextButton(
            onPressed: () {
              showchangeSearchDialog(context);
            },
            child: Icon(Icons.filter_alt_rounded))
      ],
    );
  }

  // the seach bar for the item price
  showPriceSearch() {
    streamQuery = db
        .collection('Users')
        .doc(Database().getCurrentUserID())
        .collection('stores')
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .snapshots();

    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) {
              setState(() {
                lowSearchKey = double.parse(value);
                //  this stream query matches the searchkey to the names of the items in the db
                streamQuery = db
                    .collection('Users')
                    .doc(Database().getCurrentUserID())
                    .collection('stores')
                    .doc(Database().getCurrentStoreID())
                    .collection('items')
                    .where('price', isGreaterThanOrEqualTo: lowSearchKey)
                    .where('price', isLessThan: highSearchKey)
                    .snapshots();
              });
            },
            decoration: InputDecoration(
                labelText: "Low",
                hintText: "insert lower NUMBER bound",
                prefixIcon: Icon(Icons.attach_money_rounded),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
          ),
        ),

        // this text button is just a divider between the two search bars that represent the lower and upper bounds of the price filter
        TextButton(
            onPressed: () {},
            child: Icon(Icons.remove) // this icon looks like a -
            ),

        Expanded(
          child: TextField(
            onChanged: (value) {
              setState(() {
                highSearchKey = double.parse(value);

                //  this stream query matches the searchkey to the names of the items in the db
                streamQuery = db
                    .collection('Users')
                    .doc(Database().getCurrentUserID())
                    .collection('stores')
                    .doc(Database().getCurrentStoreID())
                    .collection('items')
                    .where('price', isGreaterThanOrEqualTo: lowSearchKey)
                    .where('price', isLessThanOrEqualTo: highSearchKey)
                    .snapshots();
              });
            },
            decoration: InputDecoration(
                labelText: "High",
                hintText: "insert higher NUMBER bound",
                prefixIcon: Icon(Icons.attach_money_rounded),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
          ),
        ),
        TextButton(
            onPressed: () {
              showchangeSearchDialog(context);
            },
            child: Icon(Icons.filter_alt_rounded))
      ],
    );
  }
}

//itemDocID class
class Data{
  String itemDocID;

  Data({required this.itemDocID});
}

// //* Good reference articles... https://medium.com/firebase-tips-tricks/how-to-use-cloud-firestore-in-flutter-9ea80593ca40 ... https://www.youtube.com/watch?v=lyZQa7hqoVY
