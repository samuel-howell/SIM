import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:howell_capstone/src/screens/nav-drawer-screen.dart';
import 'package:howell_capstone/src/screens/please-choose-store-screen.dart';
import 'package:howell_capstone/src/screens/store-csv-import.dart';
import 'package:howell_capstone/src/screens/store-screen-main.dart';
import 'package:howell_capstone/src/utilities/SIMPL-export.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:howell_capstone/src/widgets/custom-alert-dialogs.dart';
import 'package:howell_capstone/theme/theme_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; 

class HomeScreen extends StatefulWidget {
  // by initializing the storedocid, and then requiring it in the const below, you are effectivley making it a parameter
  final String storeDocID;

  const HomeScreen({Key? key, required this.storeDocID})
      : super(
            key:
                key); // adding required itemDocId here will force us to pass a itemDocID to this page

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

DateTime now = DateTime.now();
String formattedDate = DateFormat('LLLL dd').format(now);

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  String name = "";
  String storeID = "";
  String totalStock = "";
  String dailyStockIn = "";
  String dailyStockOut = "";
  bool isCurrentUserAdmin = false;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Database().getCurrentStoreName().then((value) {
      print('store name is ' + value.toString());

      setState(() {
        //*IMPORTANT calling setState like so is how we take a future and turn it into a variable!!!
        name = value;
      });
    });

    setState(() {
      storeID = Database().getCurrentStoreID();
    });

    // loads the admin status for the currently logged in user when the page loads.
    Database().isCurrentUserAdmin().then((value) {
      print('ADMIN STATUS for Store ' + name + ': ' + value.toString());

      setState(() {
        isCurrentUserAdmin = value;
      });
    });

    Database().getStoreTotalStock().then((value) {
      print('store total stock is ' + value.toString());

      setState(() {
        //*IMPORTANT calling setState like so is how we take a future and turn it into a variable!!!
        totalStock = value.toString();
      });
    });

    Database().getStoreDailyStockIn().then((value) {
      print('store daily stock in is ' + value.toString());

      setState(() {
        //*IMPORTANT calling setState like so is how we take a future and turn it into a variable!!!
        dailyStockIn = value.toString();
      });
    });

    Database().getStoreDailyStockOut().then((value) {
      print('store daily stock out is ' + value.toString());

      setState(() {
        //*IMPORTANT calling setState like so is how we take a future and turn it into a variable!!!
        dailyStockOut = value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    // this is the helper method for the popup menu button
    void onSelected(BuildContext context, int item) async {
      switch (item) {
        case 0:
        if(isCurrentUserAdmin){
          showAddUserDialog(context, widget.storeDocID);
          print('store ' + widget.storeDocID +' was selected to add user to.');
        } else {
          Fluttertoast.showToast(msg: "You don't have proper privileges to add users to the store.");
        }
          break;

        case 1:
        if(isCurrentUserAdmin){
          showEditStoreDialog(context, widget.storeDocID);
          print('store ' + widget.storeDocID + ' was edited');
        } else {
          Fluttertoast.showToast(msg: "You don't have proper privileges to edit store details.");
        }
          break;

        case 2:
        if(isCurrentUserAdmin){
           await showStoreDeleteConfirmationAlertDialog(context, widget.storeDocID); // wait for store delete to finish, if you don't, it will skip the actual delete for some reason
           print('store ' + widget.storeDocID + ' was deleted');
          
        } else {
          Fluttertoast.showToast(msg: "You don't have proper privileges to delete the store.");
        }
          break;
      }
    }

    if (Database().getStoreClicked() == true) {
      return Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
        return Scaffold(
          //  import my custom navigation sidebar drawer widget and use as the drawer.
          drawer: NavigationDrawerWidget(),
          appBar: AppBar(
             actions: [
              PopupMenuButton<int>(
                  onSelected: (item) => onSelected(context, item),
                  itemBuilder: (context) => [
                        PopupMenuItem(child: Text('Add User'), value: 0),
                        PopupMenuItem(child: Text('Edit Store'), value: 1),
                        PopupMenuItem(child: Text('Delete Store'), value: 2),
                      ])
            ],
          ),
          body: SingleChildScrollView(
            child: Column(children: <Widget>[
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 10, 0),
                child: (Container(
                    alignment: Alignment.topLeft,
                    child: Text(name,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary)))),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 10, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Container(
                            child: Text('| ',
                                style: TextStyle(
                                  fontSize: 45,
                                ))),
                        Container(
                            child: Text('Store Stats ',
                                style: TextStyle(
                                  fontSize: 25,
                                ))),
                      ]),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 10, 10, 15),
                        child: Container(
                          child: InkWell(
                            child: Icon(Icons.refresh_sharp, size: 30),
                            onTap: () {
                              waitForStockRefreshDialog(
                                  context); //TODO: create a dialog that does what waitForStockRefreshDialog does and also updates total, stock out, and stock in so basically refreshes entire page

                              Database().getStoreTotalStock().then((value) {
                                print(
                                    'store total stock is ' + value.toString());

                                setState(() {
                                  //*IMPORTANT calling setState like so is how we take a future and turn it into a variable!!!
                                  totalStock = value.toString();
                                });
                              });

                              Database().getStoreDailyStockIn().then((value) {
                                print('store daily stock in is ' +
                                    value.toString());

                                setState(() {
                                  //*IMPORTANT calling setState like so is how we take a future and turn it into a variable!!!
                                  dailyStockIn = value.toString();
                                });
                              });

                              Database().getStoreDailyStockOut().then((value) {
                                print('store daily stock out is ' +
                                    value.toString());

                                setState(() {
                                  //*IMPORTANT calling setState like so is how we take a future and turn it into a variable!!!
                                  dailyStockOut = value.toString();
                                });
                              });
                            },
                          ),
                        ),
                      ),
                    ]),
              ),

              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 10, 10, 10),
                    child: Container(
                      child: Column(children: <Widget>[
                        SizedBox(height: 15),
                        Row(children: [
                          Text('Today',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          Text('     '),
                          Text(formattedDate, style: TextStyle(fontSize: 17)),
                        ]),
                        SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(children: <Widget>[
                                Text(totalStock,
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)), // TODO: put actual stock totals her pulled from database methods
                                Text('Total', style: TextStyle(fontSize: 15)),
                              ]),
                              Text(' | ',
                                  style: TextStyle(
                                    fontSize: 25,
                                  )),
                              Column(children: <Widget>[
                                Text(dailyStockOut,
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                                Text('Stock Out',
                                    style: TextStyle(fontSize: 15)),
                              ]),
                              Text(' | ',
                                  style: TextStyle(
                                    fontSize: 25,
                                  )),
                              Column(children: <Widget>[
                                Text(dailyStockIn,
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                                Text('Stock In',
                                    style: TextStyle(fontSize: 15)),
                              ]),
                            ]),
                        SizedBox(height: 15),
                      ]),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // low stock widget
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 10, 10, 10),
                    child: Container(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Column(children: <Widget>[
                          SizedBox(height: 15),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text("Low Stock",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))),
                              ]),
                          SizedBox(height: 15),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Stores')
                                  .doc(Database().getCurrentStoreID())
                                  .collection('items')
                                  .where('isAboveMinimumStockNeeded',
                                      isEqualTo: false)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Expanded(
                                    child: ListView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          DocumentSnapshot doc =
                                              snapshot.data!.docs[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    border:
                                                        Border.all(width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                                doc.get('name'),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary))),
                                                        Container(
                                                            width: 100,
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                border:
                                                                    Border.all(
                                                                        width:
                                                                            1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: Center(
                                                                child: Text(
                                                                    doc
                                                                        .get(
                                                                            'quantity')
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          17,
                                                                    )))),
                                                      ]),
                                                )),
                                          );
                                        }),
                                  );
                                }
                              }),
                          SizedBox(height: 20),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),

              // employees shared widget
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 10, 10, 10),
                    child: Container(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Column(children: <Widget>[
                          SizedBox(height: 15),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text("Shared With",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(25, 10, 10, 15),
                                  child: Container(
                                    child: InkWell(
                                      child: Icon(Icons.add, size: 30),
                                      onTap: () {
                                        if(isCurrentUserAdmin) // only allow managers to add people to the store
                                        {
                                            showAddUserDialog(context, storeID);
                                        }
                                        else{
                                          Fluttertoast.showToast(msg: "You don't have privileges to share the store.");
                                        }
                                        
                                      },
                                    ),
                                  ),
                                ),
                              ]),
                          SizedBox(height: 15),
                          StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Stores')
                                  .doc(Database().getCurrentStoreID())
                                  .collection('userAccess')
                                  .doc('sharedWith')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Expanded(
                                    child: ListView.builder(
                                        itemCount: snapshot.data!['sharedWith']
                                            .length, // get the length of the sharedWith array field  in the snapshot
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> doc = snapshot
                                              .data!['sharedWith'][index];
                                          return Slidable(
                                              actionPane:
                                                  SlidableDrawerActionPane(),
                                              actionExtentRatio: 0.25,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                                child: Text(
                                                                    (doc[
                                                                        'name'])!,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary))),
                                                            Container(
                                                                width: 100,
                                                                height: 50,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                            .red[
                                                                        300],
                                                                    border: Border.all(
                                                                        width:
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Center(
                                                                    child: Text(
                                                                        (doc['role'])!
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                        )))),
                                                          ]),
                                                    )),
                                              ),
                                              actions: <Widget>[
                                                // NOTE: using "secondaryActions" as opposed to "actions" allows us to slide in from the right instead of the left"

                                                // slide action to delete
                                                IconSlideAction(
                                                    caption: 'Delete',
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    icon: Icons.delete_sharp,
                                                    onTap: () => {
                                                          if (isCurrentUserAdmin)
                                                            {
                                                              Database()
                                                                  .deleteUserFromStore(
                                                                      doc['uid']),
                                                              print('user ' +
                                                                  doc['uid'] +
                                                                  ' was deleted.')
                                                            }
                                                          else
                                                            {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'You don\'t have privileges to delete user from store.')
                                                            }
                                                        }),

                                                
                                                // slide action to change user role 
                                                IconSlideAction(
                                                    caption: 'Change Role',
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    icon: Icons.add_moderator_outlined,
                                                    onTap: () => {
                                                          if (isCurrentUserAdmin)
                                                            {
                                                              Database()
                                                                  .changeUserSecurityLevel(
                                                                      doc['uid']),  // thisis the uid associated with the list tile that was tapped on.
                                                              print('user ' +
                                                                  doc['uid'] +
                                                                  ' role was changed.')
                                                            }
                                                          else
                                                            {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'You don\'t have privileges to change role of user.')
                                                            }
                                                        }),
                                              ]);
                                        }),
                                  );
                                }
                              }),
                          SizedBox(height: 15),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          // floatingActionButton: FloatingActionButton(onPressed: Database().refreshStoreStockTotal())
        );
      });
    } else {
      return Container();
    }
  }
}
