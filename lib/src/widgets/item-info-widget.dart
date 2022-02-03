import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:path_provider/path_provider.dart';

class ItemInfoWidget extends StatefulWidget {
  final String itemDocID;

  const ItemInfoWidget({Key? key, required this.itemDocID}) : super(key: key);

  @override
  _ItemInfoWidgetState createState() => _ItemInfoWidgetState();
}

final auth = FirebaseAuth.instance;

double storeTotalProfit = 1;

class _ItemInfoWidgetState extends State<ItemInfoWidget> {
  @override
  Widget build(BuildContext context) {
    String? currentUserID = auth.currentUser?.uid;

    //* this is how I assign a future to a var that I can actually use in the build
    //TODO: do this same method to pull in the name fo the store on the main page.
    //! I still have to comepletely exit and reenter the page before I see the new totalProfits.
    Database().getStoreTotalProfits().then((profit) {
      storeTotalProfit = profit;
      print('THE TOTAl STORE PROFIT IS ' + profit.toString());
    });

    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Stores')
                .doc(Database().getCurrentStoreID())
                .collection("items")
                .doc(widget
                    .itemDocID) // widget.itemDocId is the document id that was passed from the previous page.
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              DocumentSnapshot? userDocument =
                  snapshot.data as DocumentSnapshot<Object?>?;
              // by casting to document snapshot, we can call .get and get the individual fields from the document.


              
          return Container(
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(
                        height: 37,
                      ),
                      Text(
                        userDocument!.get('name'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 17,
                      ),
                  
                      customInfoCard(context, "Price", '\$'+userDocument.get('price').toString(), Theme.of(context).primaryColor, 0.3),
                      customInfoCard(context, "ID", userDocument.get('id').toString(), Theme.of(context).primaryColor, 0.4),
                      customInfoCard(context, "Quantity", userDocument.get('quantity').toString(), Theme.of(context).primaryColor, 0.5),
                      customInfoCard(context, "Most Recent Scan In", userDocument.get('mostRecentScanIn').toString(), Theme.of(context).primaryColor, 0.6),
                      customInfoCard(context, "Most Recent Scan Out", userDocument.get('mostRecentScanOut').toString(), Theme.of(context).primaryColor, 0.7),
                      customInfoCard(context, "Last Employee to Interact", userDocument.get('LastEmployeeToInteract').toString(), Theme.of(context).primaryColor, 0.8),
                      customInfoCard(context, "Description", userDocument.get('description').toString(), Theme.of(context).primaryColor, 0.9),
                      
                     
                    ],
                  ),
                ],
              ),
            ),
          );

                  
          
  }));
}


//-------------------------------------------------------------------------------------
String filePath ="";

Future<String> get _localPath async {
   final directory = await getApplicationSupportDirectory();
   return directory.absolute.path;
 }

Future<File> get _localFile async {
   final path = await _localPath;
   filePath = '$path/data.csv';
   return File('$path/data.csv').create();
 }







 //-------------------------------------------------------------------------------------
 

Widget customDivider(BuildContext context) {
  return Column(
    children: [
      SizedBox(height: 10),
      Divider(
        height: 20,
        thickness: 5,
        indent: 10,
        endIndent: 10,
        color: Colors.white,
      ),
      SizedBox(height: 10),
    ],
  );
}

Widget customInfoCard(BuildContext context, String identifier, String userDocumentLookUp, Color myColor, double myOpacity ) {
  return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: myColor.withOpacity(myOpacity), // color and opacity pulled in as param
              elevation: 16,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Wrap(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    margin: EdgeInsets.only(left: 10),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          identifier, // string pulled in as param
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text( userDocumentLookUp, style: TextStyle(fontSize: 18)),    
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
}

}