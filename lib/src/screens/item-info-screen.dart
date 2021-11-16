import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:universal_html/html.dart';

class ItemInfoScreen extends StatefulWidget {
    
  // by initializing the itemdocid, and then requiring it in the const below, you are effectivley making it a parameter
  final String itemDocID; 

  const ItemInfoScreen({ Key? key, required this.itemDocID}) : super(key: key); // adding required itemDocId here will force us to pass a itemDocID to this page


  @override
  _ItemInfoScreenState createState() => _ItemInfoScreenState();
}
  
  
  final auth = FirebaseAuth.instance;
  String? currentUserID = auth.currentUser?.uid;


class _ItemInfoScreenState extends State<ItemInfoScreen> {



  @override
  Widget build(BuildContext context) {

   
    return new StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Users').doc(currentUserID).collection('stores').doc(Database().getCurrentStoreID()).collection("items").doc(widget.itemDocID).snapshots(), // widget.itemDocId is the document id that was passed form the previous page.
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return new Text("Loading");
        }
        DocumentSnapshot? userDocument = snapshot.data as DocumentSnapshot<Object?>?; // by casting to document snapshot, we can call .get and get the individual fields from the document.
        return Scaffold(

          body: Column(children: [ //TODO: format this better
              Text(userDocument!.get('name'),
              style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.grey, fontSize: 26))),
              Text(userDocument.get('description'),
              style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.grey, fontSize: 26))),
              Text(userDocument.get('mostRecentScanIn'),
              style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.grey, fontSize: 26))),
          ],
          )
        );
      }
  );

 
       
  }
}

// Future<Map<String,String>> getItemDetails() async{

// DocumentReference<Map<String, dynamic>> itemDocumentReferencer = FirebaseFirestore.instance.collection('Users').doc(currentUserID).collection('stores').doc(Database().getCurrentStoreID()).collection("items").doc(widget.itemDocID);
// String name = "";
// String description = "";

//   await itemDocumentReferencer.get().then((snapshot) { // this is how we get a DocumentSnapshot from a document reference
//    name = (snapshot.get('name'));
//    description = (snapshot.get('description'));
//   });

//   return { 
//     'name':name,
//     'description':description
//   };

//}