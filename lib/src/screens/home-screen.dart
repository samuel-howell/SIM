import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:howell_capstone/src/screens/nav-drawer-screen.dart';
import 'package:howell_capstone/src/screens/please-choose-store-screen.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:howell_capstone/src/widgets/custom-alert-dialogs.dart';
import 'package:howell_capstone/theme/theme_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('LLLL dd').format(now);
class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  bool _value = false;
  String name = "";
  String totalStock = "";
  String dailyStockIn = "";
  String dailyStockOut = "";

 
      

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

  if(Database().getStoreClicked() == true) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      var counter;
      return Scaffold(
          //  import my custom navigation sidebar drawer widget and use as the drawer.
          drawer: NavigationDrawerWidget(),
          appBar: AppBar(
           
          ),
          body: SingleChildScrollView(
            child: Column(children: <Widget>[
          
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 10, 0),
            child: ( 
              Container(
                alignment: Alignment.topLeft,
                  child: Text( name,style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary))
                        )
                  ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
              Row(
                children: [ Container(
                    child: Text('| ',style: TextStyle(fontSize: 45,))
                    ), 
            
                Container(
                    child: Text('Store Stats ',style: TextStyle(fontSize: 25,))
                    ), 
                ]),

                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 10, 15),
                  child: Container(
                    child: InkWell(
                              child: Icon(Icons.refresh_sharp, size: 30),
                              onTap: () { 
                                   waitForStockRefreshDialog(context);  //TODO: create a dialog that does what waitForStockRefreshDialog does and also updates total, stock out, and stock in so basically refreshes entire page

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
                                },
                              ),
                  ),
                ),

              ]
            ),
          ),

          SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 10, 10),
                child: Container(
                  child: Column(children: <Widget>[
                    SizedBox(height:15),

                    Row(children: [
                      Text('Today', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      Text('     '),
                      Text(formattedDate, style: TextStyle(fontSize: 17)),
                    ]),

                    SizedBox(height:15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                      Column(children: <Widget>[
                        Text(totalStock, style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.primary)), // TODO: put actual stock totals her pulled from database methods
                        Text('Total', style: TextStyle(fontSize: 15)),
                      ]),

                      Text(' | ',style: TextStyle(fontSize: 25,)),

                      Column(children: <Widget>[
                        Text(dailyStockOut, style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.primary)),
                        Text('Stock Out', style: TextStyle(fontSize: 15)),
                      ]),

                      Text(' | ',style: TextStyle(fontSize: 25,)),

                      Column(children: <Widget>[
                        Text(dailyStockIn, style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.primary)),
                        Text('Stock In', style: TextStyle(fontSize: 15)),
                      ]),
                    ]),

                    SizedBox(height:15),

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
                   height: 200,
                    child: Column
                    (children: <Widget>[
                      SizedBox(height:15),
                    
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Expanded(child: Text("Low Stock", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),

                      ]),
                    
                      SizedBox(height:15),
                    
                      StreamBuilder<QuerySnapshot>(
                        
                          stream:
                              FirebaseFirestore.instance
                                    .collection('Stores')
                                    .doc(Database().getCurrentStoreID())
                                    .collection('items')
                                    .where('isAboveMinimumStockNeeded',
                                        isEqualTo:
                                            false) 
                                    .snapshots(), // this streamQuery will change based on what is typed into the search bar
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
                                          decoration: BoxDecoration(border: Border.all(width: 1), borderRadius: BorderRadius.circular(3) ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                              Expanded(child: Text(doc.get('name'), style: TextStyle(fontSize: 17, color: Theme.of(context).colorScheme.primary))),

                                              Container(
                                                width:100,
                                                height: 50,
                                                decoration: BoxDecoration(color: Colors.red, border: Border.all(width: 1), borderRadius: BorderRadius.circular(5) ),
                                                child: Center(child: Text(doc.get('quantity').toString(), style: TextStyle(fontSize: 17, )))
                                                ),
                                            ]),
                                          )
                                           
                                        ),
                                      );
                    
                                    }
                                ),
                              );
                            }
                          }
                      ),
                    
                    
                      SizedBox(height:15),
                    
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
                   height: 200,
                    child: Column
                    (children: <Widget>[
                      SizedBox(height:15),
                    
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Expanded(child: Text("Shared With", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),

                      ]),
                    
                      SizedBox(height:15),
                    
                      StreamBuilder<QuerySnapshot>(
                        
                          stream: //TODO: change this to accessing the "shared with" array field on the store doc
                              FirebaseFirestore.instance
                                    .collection('Stores')
                                    .doc(Database().getCurrentStoreID())
                                    .collection('items')
                                    .where('isAboveMinimumStockNeeded',
                                        isEqualTo:
                                            false) 
                                    .snapshots(), // this streamQuery will change based on what is typed into the search bar
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
                                          decoration: BoxDecoration(border: Border.all(width: 1), borderRadius: BorderRadius.circular(3) ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                              Expanded(child: Text(doc.get('name'), style: TextStyle(fontSize: 17, color: Theme.of(context).colorScheme.primary))),

                                              Container(
                                                width:100,
                                                height: 50,
                                                decoration: BoxDecoration(color: Colors.red, border: Border.all(width: 1), borderRadius: BorderRadius.circular(5) ),
                                                child: Center(child: Text(doc.get('quantity').toString(), style: TextStyle(fontSize: 17, )))
                                                ),
                                            ]),
                                          )
                                           
                                        ),
                                      );
                    
                                    }
                                ),
                              );
                            }
                          }
                      ),
                    
                    
                      SizedBox(height:15),
                    
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
  }
  else {
    return Container();
  }
  
  }
}


