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

 
      

 @override
  void initState() {
    super.initState();

    Database().getCurrentStoreName().then((value) {
      print('value is ' + value.toString());

      setState(() { 
      //*IMPORTANT calling setState like so is how we take a future and turn it into a variable!!!
        name = value;
      });
      });

    
  }


  @override
  Widget build(BuildContext context) {
    String? currentUserID = auth.currentUser?.uid;

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
                        Text('1435', style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.primary)), // TODO: put actual stock totals her pulled from database methods
                        Text('Total', style: TextStyle(fontSize: 15)),
                      ]),

                      Text(' | ',style: TextStyle(fontSize: 25,)),

                      Column(children: <Widget>[
                        Text('79', style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.primary)),
                        Text('Stock Out', style: TextStyle(fontSize: 15)),
                      ]),

                      Text(' | ',style: TextStyle(fontSize: 25,)),

                      Column(children: <Widget>[
                        Text('14', style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.primary)),
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


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 10, 10),
                child: Container(
                  child: Container(
                   height: 300,
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
                                      print('hit card in listview builder');
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
          ));
    });
  }
  else {
    return Container();
  }
  
  }
}


