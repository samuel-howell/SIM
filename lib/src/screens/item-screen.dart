import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howell_capstone/src/screens/item-csv-import.dart';

import 'package:howell_capstone/src/screens/item-info-screen.dart';
import 'package:howell_capstone/src/screens/nav-drawer-screen.dart';
import 'package:howell_capstone/src/utilities/SIMPL-export.dart';
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

bool lowstock = false;

// for use with csv export
List<List<String>> itemList = [];
List<Color> colorList = <Color>[];
class ItemScreen extends StatefulWidget {
  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  //String? Database().getCurrentUserID() = _auth.currentUser?.uid;

  Stream<QuerySnapshot> streamQuery = db
      .collection('Stores')
      .doc(Database().getCurrentStoreID())
      .collection('items')
      .where('lowercaseName', isGreaterThanOrEqualTo: searchKey) // adding these 2 .wheres puts the streamQuery in alphabetical order
      .where('lowercaseName', isLessThan: searchKey + 'z')
      .snapshots();

  @override
  void initState()  {
    super.initState();
    itemList = [
      <String>["ITEM", "QUANTITY"]
    ]; // we have to reset storeList  to empty every time the page is built. we add one entry <String>["STORE", "ADDRESS"] to serve as a headers though.

    colorList = <Color>[]; // we have to reset colorList  to empty every time the page is built so the indexes work properly.
 
//if true, add green to list. if false, add red.  
//Then iterate through list in listview builder to color each container holding quantity correctly
    //updateQuantityColors();
   
  }


  @override
  Widget build(BuildContext context) {
    
      // this is the helper method for the popup menu button
      void onSelected(BuildContext context, int item) async {
        switch (item) {
          case 0:
            showAddItemDialog(context);
            break;

          case 1:
            SIMPLExport().exportItemCsv();
            break;

          case 2:
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ItemCsvImport(),
            ));
            break;

        }
      }

      return FutureBuilder(
          future: updateQuantityColors(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting)
            {
              return Center(
                    child: CircularProgressIndicator(),
                  );
            }

          else if (snapshot.connectionState == ConnectionState.done) {
        return Scaffold(
          drawer: NavigationDrawerWidget(),
          appBar: AppBar(actions: [
            PopupMenuButton<int>(
                onSelected: (item) => onSelected(context, item),
                itemBuilder: (context) => [
                      PopupMenuItem(
                          child: Text('Add New Item'),
                          value:
                              0 // this is the value that will be passed when we press on this popup menu item
                          ),
                      PopupMenuItem(
                          child: Text('Export Store Items'), value: 1),
      
                      PopupMenuItem(
                          child: Text('Import Store Items'), value: 2),
                    ])
          ]),
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
                                child: GestureDetector(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary, // color and opacity pulled in as param
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
                                                  Center(
                                                    child: Text(
                                                      doc
                                                          .get('name')
                                                          .toString(), // string pulled in as param
                                                      style: TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
      
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children:[
                                                  Text(
                                                      "\$" +
                                                          doc
                                                              .get('price')
                                                              .toString() +
                                                          " ",
                                                      style: TextStyle(
                                                          fontSize: 18)),
      
                                                  SizedBox(
                                                    height: 10,
                                                  ),
      
                                                  Text(
                                                      "ID: " +
                                                          doc
                                                              .get('id')
                                                              .toString() +
                                                          " ",
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                        ]),
      
                                                  Container(
                                                width: 100,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: colorList[index], // add the color found at the matching index in the color list
                                                  borderRadius: BorderRadius.circular(10),), //TODO: build out database function that determines whether an item is in low stock
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Center(child: Text(doc.get('quantity').toString(), style: TextStyle(fontSize: 18))),
                                                ),
                                                 )
                                                ]),
                                              ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () => {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ItemInfoScreen(
                                                    itemDocID: doc.id), // pass the doc id to the item infor screen page
                                              ))
                                        }),
                                actions: <Widget>[
                                  // NOTE: using "secondaryActions" as opposed to "actions" allows us to slide in from the right instead of the left"
      
                                  // slide action to delete
                                  IconSlideAction(
                                      caption: 'Delete',
                                      color: Theme.of(context).primaryColor,
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
                                      color:
                                          Theme.of(context).colorScheme.secondary,
                                      icon: Icons.edit,
                                      onTap: () => {
                                            showEditItemDialog(context, doc.id),
                                            print(
                                                'item ' + doc.id + ' was edited')
                                          }),
                                ]
                                );
      
                        
                          }),
                    )
                  ]));
                }
              }),
        );
          }
          else {return Text("Snapshot error");}
           } );
   
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
        .collection('Stores')
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
                  .collection('Stores')
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
                    .collection('Stores')
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
        .collection('Stores')
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
                    .collection('Stores')
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
                    .collection('Stores')
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


  //iterate through items to populate color list
 updateQuantityColors() async {

  
    /*
  In order to color a quantity container either red or green depending on if it is below minimum stock needed, we need to make a list of
  colors where each index corresponds with the appropriate index in the itemlist that is generated with the Listview.builder.  then, we can just 
  use colorList[index] in the listview.builder when defining the color for the quantity container for each item.  We can't do await methods in listview builder, so this was the workaround.

  We use futurebuilder to generate the correct item list everytime the page is rebuilt
   */

  QuerySnapshot querySnapshot = await db.collection('Stores').doc(Database().getCurrentStoreID()).collection('items').get();
  for (int i = 0; i < querySnapshot.docs.length; i++) {
    var doc = querySnapshot.docs[i];
    print(doc.get('name'));

  bool isAboveMinimumStock = await Database.isAboveMinimumStockNeeded(itemDocID: doc.id);

    print('isAboveMinimumStock is ' + isAboveMinimumStock.toString());

  if(isAboveMinimumStock){
    colorList.add(Colors.green[700]!);
  } 
  else {
    colorList.add(Colors.red[400]!);
    }

    print('colorList is now ' + colorList.toString());
    print('colorList[0] is ' + colorList[0].toString());

  }
}
//itemDocID class
class Data {
  String itemDocID;

  Data({required this.itemDocID});
}

// //* Good reference articles... https://medium.com/firebase-tips-tricks/how-to-use-cloud-firestore-in-flutter-9ea80593ca40 ... https://www.youtube.com/watch?v=lyZQa7hqoVY
