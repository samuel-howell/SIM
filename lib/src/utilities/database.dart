import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('Users');

final FirebaseAuth _auth = FirebaseAuth.instance;
getCurrentUserUid() {
    print('Current user id is ' + _auth.currentUser!.uid.toString());
  }

class Database {

  static Future<void> addItem({
    required String name,
    required String description,
    required String price,
    required String quantity,
    //required String itemID,
    required String mostRecentScanIn,
  }) async {

    getCurrentUserUid(); // prints the uid out to the console for testing




    DocumentReference documentReferencer =
    //TODO: doesnt need to be based on (_auth.currentUser?.uid, it need to be based on the store ID, but only certain users have certain store IDS
        _mainCollection.doc(_auth.currentUser?.uid).collection('items').doc(); // finds the location of the documentCollection of the current user that is signed in and then creates a new document under the "items" collection in that user's documentCollection

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "description": description,
      "price": price,
      "quantity": quantity,
      //"item-id": itemID, //TODO: this is authogenerated. it is thge random strings under the items tab in firebase. find a way to pull that string in explicitly here.
      "mostRecentScanIn" : mostRecentScanIn,
      "LastEmployeeToInteract" : _auth.currentUser?.uid, //this will be the user id of the last employee to either scan in or scan out the item
      "tags" : [] //TODO: let the user add tags to id this item with. ideally add the tags as an array.
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Item added to the database"))
        .catchError((e) => print(e));
  }








  static Future<void> addStore({
    required String name,
    required String address,
  }) async {
    DocumentReference documentReferencer =
    //TODO: doesnt need to be based on (_auth.currentUser?.uid, it need to be based on the store ID, but only certain users have certain store IDS
        _mainCollection.doc(_auth.currentUser?.uid).collection('stores').doc(); // finds the location of the documentCollection of the current user that is signed in and then creates a new document under the "stores" collection in that user's documentCollection

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "address": address,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Store added to the database"))
        .catchError((e) => print(e));
  }
}