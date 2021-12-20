import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:howell_capstone/src/widgets/line-chart-widget.dart';

class ItemInfoScreen extends StatefulWidget {
  // by initializing the itemdocid, and then requiring it in the const below, you are effectivley making it a parameter
  final String itemDocID;

  const ItemInfoScreen({Key? key, required this.itemDocID})
      : super(
            key:
                key); // adding required itemDocId here will force us to pass a itemDocID to this page

  @override
  _ItemInfoScreenState createState() => _ItemInfoScreenState();
}

final auth = FirebaseAuth.instance;

class _ItemInfoScreenState extends State<ItemInfoScreen> {
  @override
  Widget build(BuildContext context) {
    String? currentUserID = auth.currentUser?.uid;

    return Scaffold(
        appBar: AppBar(
            title: Text('Item Information Screen'),
            centerTitle: true,
            backgroundColor: Colors.black),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUserID)
                .collection('stores')
                .doc(Database().getCurrentStoreID())
                .collection("items")
                .doc(widget.itemDocID)
                .snapshots(), // widget.itemDocId is the document id that was passed from the previous page.
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              DocumentSnapshot? userDocument = snapshot.data as DocumentSnapshot<
                  Object?>?;
                   // by casting to document snapshot, we can call .get and get the individual fields from the document.
              return Scaffold(
                body: Align(
                  alignment: Alignment.topLeft,
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return SingleChildScrollView(
                        child: Column(children: [
                          Row(children: [
                            Container(
                                height: constraints.maxHeight / 6,
                                width: MediaQuery.of(context).size.width,
                                //color: Colors.red,
                                        
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Item Name:',
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20))),
                                      Text(userDocument!.get('name'),
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20))),
                                    ])),
                          ]),
                          Row(children: [
                            Container(
                                height: constraints.maxHeight / 6,
                                width: MediaQuery.of(context).size.width,
                                //color: Colors.green,
                                        
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Last Employee to Interact:',
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20))),
                                      Text(
                                          userDocument
                                              .get('LastEmployeeToInteract'),
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20))),
                                    ])),
                          ]),
                          Row(children: [
                            Container(
                                height: constraints.maxHeight / 6,
                                width: MediaQuery.of(context).size.width,
                                //color: Colors.red,
                                        
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text('Most Recent Scan In:',
                                            style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20))),
                                      ),
                                      Expanded(
                                        child: Text(
                                            userDocument
                                                .get('mostRecentScanIn')
                                                .toString(),
                                            style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20))),
                                      ),
                                        
                                      SizedBox(height: 25,),
                                        
                                      Text('Most Recent Scan Out:',
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20))),
                                      Text(
                                          userDocument
                                              .get('mostRecentScanOut')
                                              .toString(),
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20))),
                                    ])),
                                    
                          ]),
                          Row(children: [
                            Container(
                                height: constraints.maxHeight / 4,
                                width: MediaQuery.of(context).size.width / 2,
                                //color: Colors.orange,
                                        
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Item ID:',
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20))),
                                      Text(userDocument.get('id'),
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20))),
                                    ])),
                            Container(
                                height: constraints.maxHeight / 4,
                                width: MediaQuery.of(context).size.width / 2,
                                //color: Colors.purple,
                                        
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Description:',
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20))),
                                      Text(userDocument.get('description'),
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20))),
                                    ])),
                          ]),
                          Row(children: [
                            Container(
                                height: constraints.maxHeight / 4,
                                width: MediaQuery.of(context).size.width / 2,
                                //color: Colors.blue,
                                        
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Price:',
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20))),
                                      Text(userDocument.get('price').toString(),
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20))),
                                    ])),
                            Container(
                                height: constraints.maxHeight / 4,
                                width: MediaQuery.of(context).size.width / 2,
                                //color: Colors.blue,
                                        
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Quantity:',
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20))),
                                      Text(
                                          userDocument.get('quantity').toString(),
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20))),
                                    ])),
                          ]),
                                        
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Text('Quantity Graph', textAlign: TextAlign.center),
                                SizedBox(
                                  height: 70,
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height/2,
                                  width: MediaQuery.of(context).size.width,
                                  child: LineChartWidget(itemID: widget.itemDocID)), // pas the itemID as a named param to the LineChartWidget
                                ]
                                )
                                ),
                        ]),
                      );
                    },
                  ),
                ),
              );
            }));
  }
}
