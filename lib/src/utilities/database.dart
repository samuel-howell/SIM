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
    required String description,
    required String price,
    required String quantity,
    //required String itemID,
    required String mostRecentScanIn,
  }) async {

    DocumentReference documentReferencer =
        _userCollection.doc(currentUserUID).collection('stores').doc(/*! THIS NEEDS TO BE tHJE MOST RECENT STORE ID CLICKED IN Store Listview on store-screen page*/Database.currentStoreID).collection('items').doc();   // current user -> store -> items -> *insert the new item here in this blank doc*

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "description": description,
      "price": price,
      "quantity": quantity,
      //"item-id": itemID, //TODO: this is authogenerated. it is the random strings under the items tab in firebase. find a way to pull that string in explicitly here.
      "mostRecentScanIn" : mostRecentScanIn,
      "LastEmployeeToInteract" : currentUserUID, //this will be the user id of the last employee to either scan in or scan out the item
      "tags" : [] //TODO: let the user add tags to id this item with. ideally add the tags as an array.
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Item added to the store with the ID :  " + Database.currentStoreID.toString()))
        .catchError((e) => print(e));
  }


//  method to  add a store
  static Future<void> addStore({
    required String name,
    required String address,
    //required String storeID,
  }) async {
    DocumentReference documentReferencer =
        _userCollection.doc(currentUserUID).collection('stores').doc(); // finds the location of the documentCollection of the current user that is signed in and then creates a new document under the "stores" collection in that user's documentCollection

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "address": address,
      "storeID" : " ", //TODO:MAY NOT BE NEEDED. find a way to add doc.id from store-screen.dart to here. storeID is jus the document id of that particular store. update the store id value.
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Store added to the database"))
        .catchError((e) => print(e));
  }




  static String currentStoreID = ""; // making it static means it simply belongs to the class, so I don't have to have an instance of the class to call it in other .dart files (like store-screen) 

  //  method to get a currentStoreID
  String getCurrentStoreID(){
    return currentStoreID;
  }

  //method to set a store id
  static setcurrentStoreID(String id) {
    currentStoreID = id;
  }
}

