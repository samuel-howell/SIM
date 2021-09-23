import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _userCollection = _firestore.collection('Users');
final FirebaseAuth _auth = FirebaseAuth.instance;

final currentUserUID = _auth.currentUser?.uid;

getcurrentUserUIDUid() {
    print('Current user id is ' + _auth.currentUser!.uid.toString());
  }

class Database {


//  method to  add an item
  static Future<void> addItem({
    required String name,
    required String price,
    required String quantity,
    required String description,
    required String mostRecentScanIn,
  }) async {

    DocumentReference itemDocumentReferencer =
        _userCollection.doc(currentUserUID).collection('stores').doc(Database.currentStoreID).collection('items').doc();   // current user -> store -> items -> *insert the new item here in this blank doc*

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "description": description,
      "price": price,
      "quantity": quantity,
      "item-id": itemDocumentReferencer.id, 
      "mostRecentScanIn" : mostRecentScanIn,
      "LastEmployeeToInteract" : currentUserUID, //this will be the user id of the last employee to either scan in or scan out the item
      "tags" : [] //TODO: let the user add tags to id this item with. ideally add the tags as an array.
    };

    await itemDocumentReferencer
        .set(data)
        .whenComplete(() => print("Item added to the store with the ID :  " + Database.currentStoreID.toString()))
        .catchError((e) => print(e));
  }


//  method to  add a store
  static Future<void> addStore({
    required String name,
    required String address,
  }) async {
    DocumentReference storeDocumentReferencer =
        _userCollection.doc(currentUserUID).collection('stores').doc(); // finds the location of the documentCollection of the current user that is signed in and then creates a new document under the "stores" collection in that user's documentCollection

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "address": address,
      "storeID" : storeDocumentReferencer.id, 
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
    DocumentReference storeDocumentReferencer =
        _userCollection.doc(currentUserUID).collection('stores').doc(docID); // finds the location of the documentCollection of the current user that is signed in and then creates a new document under the "stores" collection in that user's documentCollection

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "address": address,
      "storeID" : storeDocumentReferencer.id, 
    };

    await storeDocumentReferencer
        .update(data)
        .whenComplete(() => print("Store added to the database"))
        .catchError((e) => print(e));
  }


//  method to update an item
  static Future<void> editItem({
    required String name,
    required String price,
    required String quantity,
    required String description,
    //required String mostRecentScanIn,  //! do i really need this here?
    required String itemDocID

  }) async {
    DocumentReference itemDocumentReferencer =
        _userCollection.doc(currentUserUID).collection('stores').doc(Database().getCurrentStoreID()).collection('items').doc(itemDocID); // finds the location of the documentCollection of the current user that is signed in and then creates a new document under the "stores" collection in that user's documentCollection

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "price": price,
      "quantity": quantity,
      "tags": [],
      "description" : description,
      "LastEmployeeToInteract": currentUserUID,
      "item-id" : itemDocumentReferencer.id, 
      //"mostRecentScanIn" : mostRecentScanIn  //! do i really need this here?
    };

    await itemDocumentReferencer
        .update(data)
        .whenComplete(() => print("Store added to the database"))
        .catchError((e) => print(e));
  }





  static String currentStoreID = ""; // making it static means it simply belongs to the class, so I don't have to have an instance of the class to call it in other .dart files (like store-screen) 
  static bool isSelected = false;

  //  method to get a currentStoreID
  String getCurrentStoreID(){
    return currentStoreID;
  }

  //method to set a store id
  static setcurrentStoreID(String storeID) {
    currentStoreID = storeID;
  }
}

