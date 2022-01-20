import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:howell_capstone/src/screens/item-info-screen.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:howell_capstone/src/widgets/custom-alert-dialogs.dart';
import 'package:howell_capstone/theme/custom-colors.dart';


//  gets the current user id
final FirebaseAuth _auth = FirebaseAuth.instance;

//accesses the firebase database
final db = FirebaseFirestore.instance;



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
            centerTitle: true,
            ),
        body: StreamBuilder<QuerySnapshot>(
            stream:
                streamQuery, // this streamQuery will change based on what is typed into the search bar
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
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];

                          // the slideable widget allows us to use slide ios animation to bring up delete and edit dialogs
                          return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: 
                              

                              GestureDetector(
                                child: Container(
                                      height: 100.0,
                                      margin: new EdgeInsets.all(10.0),
                                      decoration: new BoxDecoration(borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                                          gradient: new LinearGradient(colors: [Theme.of(context).primaryColor, Theme.of(context).colorScheme.secondary],
                                              begin: Alignment.centerLeft, end: Alignment.centerRight, tileMode: TileMode.clamp)),
                                      child: new Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          new Padding(padding: new EdgeInsets.only(left: 10.0, right: 10.0),
                                            //child: new CircleAvatar(radius: 35.0, backgroundImage: NetworkImage('https://wallpapercave.com/wp/wp2365076.jpg'),)
                                          ),
                                          new Expanded(child: new Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Text(doc.get('name'), style: new TextStyle(fontSize: 20.0, color: Colors.white70, fontWeight: FontWeight.bold),),
                                              new SizedBox(height: 8.0,),
                                              new Text('\$' + doc.get('price').toString(), style: new TextStyle(fontSize: 17.0, color: Colors.white70),),
                                              new SizedBox(height: 10.0,),
                                              new Row(children: <Widget>[
                              
                                              ],)
                                            ],)),
                                          new Padding(padding: new EdgeInsets.only(left: 10.0, right: 10.0),
                                            child: new Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                              new Text('ID: ' + doc.get('id').toString(), style: new TextStyle(fontSize: 17.0, color: Colors.white70),),
                                            ],))
                              
                                        ],),
                              
                                ),
                                onTap: () => {
                                  Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ItemInfoScreen(
                                              itemDocID: doc
                                                  .id), // pass the doc id to the item infor screen page
                                        ))
                                }
                              ),


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
                                          print('item ' +
                                              doc.id +
                                              ' was deleted.')
                                        }),

                                // slide action to edit
                                IconSlideAction(
                                    caption: 'Edit',
                                    color: CustomColors.red,
                                    icon: Icons.edit,
                                    onTap: () => {
                                          showEditItemDialog(context, doc.id),
                                          print(
                                              'item ' + doc.id + ' was edited')
                                        }),
                              ]);
                        }),
                  )
                ]));
              }
            }),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.post_add),
          onPressed: () => {
            showAddItemDialog(context) 
          },
        ),
      );
    } catch (e) {
      //! this code isn't working.
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
                border: OutlineInputBorder()),
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
                border: OutlineInputBorder()),
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
class Data {
  String itemDocID;

  Data({required this.itemDocID});
}

// //* Good reference articles... https://medium.com/firebase-tips-tricks/how-to-use-cloud-firestore-in-flutter-9ea80593ca40 ... https://www.youtube.com/watch?v=lyZQa7hqoVY
