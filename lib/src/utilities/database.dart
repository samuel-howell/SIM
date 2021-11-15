import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _userCollection = _firestore.collection('Users');
final FirebaseAuth _auth = FirebaseAuth.instance;

String? currentUserUID = _auth.currentUser?.uid;


bool storeIsClicked = false; // this is the value that determines whether the user has selected a store (thus determining whether the app directs to an custom error page or the item page.)
String storeName = "null"; // this is the store name that will be assigned in some of the methods below

getcurrentUserUIDUid() {
  print('Current user id is ' + _auth.currentUser!.uid);
}

class Database {
//  method to  add an item
  static Future<void> addItem(
      {required String name,
      required double price,
      required int quantity,
      required String description,
      required String mostRecentScanIn,
      required String id}) async {

    String? currentUserUID = _auth.currentUser?.uid; // get the current user id at the moment the method has been triggered //! why do i need to do this. shouldnt the overal currentUserUID handle it?
    DocumentReference itemDocumentReferencer = _userCollection
        .doc(currentUserUID)
        .collection('stores')
        .doc(Database.currentStoreID)
        .collection('items')
        .doc(id); // current user -> store -> items -> *insert the new item here in this blank doc and make its id the item id entered by user*

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "lowercaseName": name.toLowerCase(), // for use with the search bar

      "description": description,
      "price": price,
      "quantity": quantity,

      "id": id,
      "db-item-id": itemDocumentReferencer.id,

      "mostRecentScanIn": mostRecentScanIn,
      "LastEmployeeToInteract":
          currentUserUID, //this will be the user id of the last employee to either scan in or scan out the item
      "tags":
          [] //TODO: let the user add tags to id this item with. ideally add the tags as an array. when adding an item and editing, allow the user to edit and add tags
    };

    await itemDocumentReferencer
        .set(data)
        .whenComplete(() => print("Item added to the store with the ID :  " +
            Database.currentStoreID.toString()))
        .catchError((e) => print(e));
  }

//  method to  add a user
  static Future<void> addUser({
    required String firstName,
    required String lastName,
    required String email,
    required String dateAccountCreated,
    required String userID,
    required bool emailVerified,
  }) async {
    DocumentReference userDocumentReferencer = _userCollection.doc(userID);
    Map<String, dynamic> data = <String, dynamic>{
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "userID": userID,
      "dateAccountCreated": dateAccountCreated,
    };

    await userDocumentReferencer
        .set(data)
        .whenComplete(() => print("User added"))
        .catchError((e) => print(e));
  }



//  method to delete a store
  static Future<void> deleteStore(String storeDocID)async{
          String? currentUserUID = _auth.currentUser?.uid; // get the current user id at the moment the method has been triggered 

           await  _userCollection
          .doc(currentUserUID)
          .collection('stores')
          .doc(Database().getCurrentStoreID())
          .collection('items')
          .doc(storeDocID)
          .delete();

          print('the delete button was pressed.and the store id was ' + storeDocID.toString());

  }

  //  method to delete a store
  static Future<void> deleteItem(String itemDocID)async{
          String? currentUserUID = _auth.currentUser?.uid; // get the current user id at the moment the method has been triggered 

           await  _userCollection
          .doc(currentUserUID)
          .collection('stores')
          .doc(Database().getCurrentStoreID())
          .collection('items')
          .doc(itemDocID)
          .delete();

          print('the delete buttonnnnnwas pressed.and the item id was ' + itemDocID.toString());

  }

//  method to  add a store
  static Future<void> addStore({
    required String name,
    required String address,
  }) async {

    String? currentUserUID = _auth.currentUser?.uid; // get the current user id at the moment the method has been triggered
    DocumentReference storeDocumentReferencer = _userCollection
        .doc(currentUserUID)
        .collection('stores')
        .doc(); // finds the location of the documentCollection of the current user that is signed in and then creates a new document under the "stores" collection in that user's documentCollection

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "lowercaseName": name.toLowerCase(),
      "address": address,
      "lowercaseAddress": address.toLowerCase(),
      "storeID": storeDocumentReferencer.id,
    };

    await storeDocumentReferencer
        .set(data)
        .whenComplete(() => print("Store added to the database"))
        .catchError((e) => print(e));
  }

//method to update a store
  static Future<void> editStore({
    required String name,
    required String address,
    required String docID,
  }) async {

    String? currentUserUID = _auth.currentUser?.uid; // get the current user id at the moment the method has been triggered
    DocumentReference storeDocumentReferencer = _userCollection
        .doc(currentUserUID)
        .collection('stores')
        .doc(
            docID); // finds the location of the documentCollection of the current user that is signed in and then creates a new document under the "stores" collection in that user's documentCollection

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "address": address,
      "storeID": storeDocumentReferencer.id,
    };

    await storeDocumentReferencer
        .update(data)
        .whenComplete(() => print("Store updated in the database"))
        .catchError((e) => print(e));
  }

//  method to update an item
  static Future<void> editItem(
      {required String name,
      required double price,
      required int quantity,
      required String description,
      required String itemDocID}) async {

    String? currentUserUID = _auth.currentUser?.uid; // get the current user id at the moment the method has been triggered
    DocumentReference itemDocumentReferencer = _userCollection
        .doc(currentUserUID)
        .collection('stores')
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc(
            itemDocID); // finds the location of the documentCollection of the current user that is signed in and then creates a new document under the "stores" collection in that user's documentCollection

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "price": price,
      "quantity": quantity,
      "tags": [],
      "description": description,
      "LastEmployeeToInteract": currentUserUID, //TODO: change this to the user's name 
      "item-id": itemDocumentReferencer.id,
    };

    await itemDocumentReferencer
        .update(data)
        .whenComplete(() => print("item edited in the database"))
        .catchError((e) => print(e));
  }

//  method to update item count in database by one (called each time qr code is scanned)
  static Future<void> incrementItemQuantity(String qrCode) async {
    int quantity = 0;
    int newQuantity = 0;

    String? currentUserUID = _auth.currentUser?.uid;
    DocumentReference itemDocumentReferencer = _userCollection
        .doc(currentUserUID)
        .collection('stores')
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc(qrCode); // finds the document associate with the id read by the qr code scanner

//TODO:  use this same code below to get the name of the current user, and insert that in the lastEMployeeToInteract 
  await itemDocumentReferencer.get().then((snapshot) { // this is how we get a DocumentSnapshot from a document reference
    quantity = (snapshot.get('quantity'));
    newQuantity = quantity + 1;
  });
    Map<String, dynamic> data = <String, dynamic>{
      "quantity": newQuantity,
    };

    await itemDocumentReferencer
        .update(data)
        .whenComplete(() => print("item quantity increemeted in the database"))
        .catchError((e) => print(e));
  }
 



  static String currentStoreID =
      ""; // making it static means it simply belongs to the class, so I don't have to have an instance of the class to call it in other .dart files (like store-screen)
  static bool isSelected = false;

  //  method to get a currentStoreID
  String getCurrentStoreID() {
    return currentStoreID;
  }

   static String? getCurrentUserID() {
    String? currentUserID = _auth.currentUser?.uid;
    return currentUserID;
  }


  //method to set a store id
  static setcurrentStoreID(String storeID) {
    currentStoreID = storeID;
  }


 //  sets whether store has been clicked
 setStoreClicked(bool val){
    storeIsClicked = val;
  }

 // gets whether store has been clicked
 getStoreClicked() {
   return storeIsClicked;
 }



//This looks at a snapshot of the store and pulls its name out, sending it to a helper method which converts the <Future>String to String
 Future<String> getSelectedStoreName() async {
  String? currentUserUID = _auth.currentUser?.uid;
  String storeName ="null";

  DocumentReference storeDocumentReferencer = _userCollection
        .doc(currentUserUID)
        .collection('stores')
        .doc(Database().getCurrentStoreID());
        

  await storeDocumentReferencer.get().then((snapshot) { // this is how we get a DocumentSnapshot from a document reference
    storeName = (snapshot.get('name'));
  });
 
 print('THIS is THe STORE NAME ' + storeName);

return storeName; //TODO: this is return Future Stirng 
 }


//TODO: cant return a Future<String> as a string. figure out a way to get around thus
Future<String> getStoreName() async {
  String storeName = "null at first";
    print('storename started as ' + storeName);

    await Database().getSelectedStoreName().then((value){
      print('the value that is getSelectedStoreName is ' + value); // this is correct
      storeName = value.toString();
    });
    print('storename ended as ' + storeName);
    return storeName ;
}
 

}


