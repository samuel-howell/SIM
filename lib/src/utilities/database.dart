import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:howell_capstone/src/utilities/store-data-classes.dart';
import 'package:howell_capstone/src/widgets/line-chart-month/line-data-month.dart';
import 'package:howell_capstone/src/widgets/line-chart-day/line-data-day.dart';
import 'package:howell_capstone/src/widgets/line-chart-year/line-data-year.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _userCollection = _firestore.collection('Users');
final CollectionReference _storeCollection = _firestore.collection('Stores');
final FirebaseAuth _auth = FirebaseAuth.instance;

String? currentUserUID = _auth.currentUser?.uid;

bool storeIsClicked =
    false; // this is the value that determines whether the user has selected a store (thus determining whether the app directs to an custom error page or the item page.)
String storeName =
    "null"; // this is the store name that will be assigned in some of the methods below

getcurrentUserUIDUid() {
  print('Current user id is ' + _auth.currentUser!.uid);
}

class Database {
  //! //////////////////////////////////////////////      ADD     /////////////////////////////////////////
//  method to  add an item
  static Future<void> addItem({
    required String name,
    required double price,
    required int quantity,
    required String description,
    required String mostRecentScanIn,
    required String id,
  }) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MM/dd/yyyy - HH:mm')
        .format(now); // format the date like "11/15/2021 - 16:52"

//*@@@@@@@@@@@@@@@@@@@@@@@@@@@
    // String? currentUserUID = _auth.currentUser
    //     ?.uid; // get the current user id at the moment the method has been triggered //! why do i need to do this. shouldnt the overal currentUserUID handle it?
    // DocumentReference itemDocumentReferencer = _userCollection
    //     .doc(currentUserUID)
    //     .collection('stores')
    //     .doc(Database.currentStoreID)
    //     .collection('items')
    //     .doc(
    //         id); // current user -> store -> items -> *insert the new item here in this blank doc and make its id the item id entered by user*

    // DocumentReference quantityDoc = _userCollection
    //     .doc(currentUserUID)
    //     .collection('stores')
    //     .doc(Database.currentStoreID)
    //     .collection('items')
    //     .doc(id)
    //     .collection('graphData')
    //     .doc('quantity');
//*@@@@@@@@@@@@@@@@@@@@@@@@@@@

        String? currentUserUID = _auth.currentUser
                ?.uid; // get the current user id at the moment the method has been triggered //! why do i need to do this. shouldnt the overal currentUserUID handle it?
            DocumentReference itemDocumentReferencer = _storeCollection
                .doc(Database.currentStoreID)
                .collection('items')
                .doc(
                    id); // current user -> store -> items -> *insert the new item here in this blank doc and make its id the item id entered by user*

            DocumentReference quantityDoc = _storeCollection
                .doc(Database.currentStoreID)
                .collection('items')
                .doc(id)
                .collection('graphData')
                .doc('quantity');

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "lowercaseName": name.toLowerCase(), // for use with the search bar

      "description": description,
      "price": price,
      "quantity": quantity,

      "id": id,
      "db-item-id": itemDocumentReferencer.id,

      "mostRecentScanIn": mostRecentScanIn,
      "mostRecentScanOut": "", // initiliaze to null until first scan out

      "LastEmployeeToInteract": await Database().getCurrentUserName(), //this will be the user id of the last employee to either scan in or scan out the item
    };

    Map<String, dynamic> firstQuantityDataPoint = <String, dynamic>{
      "dataPoints": [
        {"quantity": quantity, "date": now}
      ],
    };

    await quantityDoc
        .set(firstQuantityDataPoint)
        .whenComplete(() => print("added firstQuantityDataPoint"))
        .catchError((e) => print(e));

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


//  method to  add a user access to a store
  static Future<void> addStoreUser({
    required String email,
    required String docID,
  }) async {
    DocumentReference storeDocumentReferencer = _storeCollection.doc(docID);
   

    await storeDocumentReferencer
        .set({
          "sharedWith": FieldValue.arrayUnion([
            {"UID": await Database().getUserUIDFromEmail(email), "Name": await Database().getUserNameFromEmail(email), "Email": email}
          ])
        }, SetOptions(merge: true))
        .whenComplete(() => print("user added to the store " + Database.currentStoreID.toString()))
        .catchError((e) => print(e));
  }

//  method to  add a store
  static Future<void> addStore({
    required String name,
    required String address,
  }) async {

    DocumentReference storeDocumentReferencer = _storeCollection
        .doc(); 


    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "lowercaseName": name.toLowerCase(),
      "address": address,
      "lowercaseAddress": address.toLowerCase(),
      "storeID": storeDocumentReferencer.id,
      "sharedWith": [],  // init an array to store all the user uids that can access this particular store
      "createdBy:": Database().getCurrentUserID()
    };

    await storeDocumentReferencer
        .set(data)
        .whenComplete(() => print("Store added to the database"))
        .catchError((e) => print(e));
  }

  //! //////////////////////////////////////////////      DELETE    /////////////////////////////////////////

//  method to delete a store
  static Future<void> deleteStore(String storeDocID) async {


//*@@@@@@@@@@@@@@@@@@@@@@@@@@@
    // await _userCollection
    //     .doc(currentUserUID)
    //     .collection('stores')
    //     .doc(Database().getCurrentStoreID())
    //     .collection('items')
    //     .doc(storeDocID)
    //     .delete();
//*@@@@@@@@@@@@@@@@@@@@@@@@@@@

    await _storeCollection
        .doc(storeDocID)
        .delete();

    print('the delete button was pressed.and the store id was ' +
        storeDocID.toString());
  }

//  method to delete a item
  static Future<void> deleteItem(String itemDocID) async {
    String? currentUserUID = _auth.currentUser
        ?.uid; // get the current user id at the moment the method has been triggered

//*@@@@@@@@@@@@@@@@@@@@@@@@
    // await _userCollection
    //     .doc(currentUserUID)
    //     .collection('stores')
    //     .doc(Database().getCurrentStoreID())
    //     .collection('items')
    //     .doc(itemDocID)
    //     .delete();
//*@@@@@@@@@@@@@@@@@@@@@@@@

    await _storeCollection
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc(itemDocID)
        .delete();


    print('the delete buttonnnnnwas pressed.and the item id was ' +
        itemDocID.toString());
  }

  //! //////////////////////////////////////////////      UPDATE   /////////////////////////////////////////

//method to update a store
  static Future<void> editStore({
    required String name,
    required String address,
    required String docID,
  }) async {

    //*@@@@@@@@@@@@@@@@@@@@@@@@@@@
    // String? currentUserUID = _auth.currentUser
    //     ?.uid; // get the current user id at the moment the method has been triggered
    // DocumentReference storeDocumentReferencer = _userCollection
    //     .doc(currentUserUID)
    //     .collection('stores')
    //     .doc(
    //         docID); // finds the location of the documentCollection of the current user that is signed in and then creates a new document under the "stores" collection in that user's documentCollection
    //*@@@@@@@@@@@@@@@@@@@@@@@@@@@


    String? currentUserUID = _auth.currentUser
        ?.uid; // get the current user id at the moment the method has been triggered
    DocumentReference storeDocumentReferencer = _storeCollection
        .doc(
            docID); // finds the location of the documentCollection of the current user that is signed in and then creates a new document under the "stores" collection in that user's documentCollection


    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "address": address,
      "lowercaseAddress": address.toLowerCase(),
      "lowercaseName": name.toLowerCase(),
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
    String? currentUserUID = _auth.currentUser
        ?.uid; // get the current user id at the moment the method has been triggered

    //  this doc ref finds the item doc
    //*@@@@@@@@@@@@@
    // DocumentReference itemDocumentReferencer = _userCollection
    //     .doc(currentUserUID)
    //     .collection('stores')
    //     .doc(Database().getCurrentStoreID())
    //     .collection('items')
    //     .doc(
    //         itemDocID); // finds the location of the documentCollection of the current user that is signed in and then creates a new document under the "stores" collection in that user's documentCollection
    //*@@@@@@@@@@@@@

        DocumentReference itemDocumentReferencer = _storeCollection
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc(
            itemDocID); 

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "lowercaseName": name.toLowerCase(),
      "price": price,
      "quantity": quantity,
      "tags": [],
      "description": description,
      "LastEmployeeToInteract": await Database().getCurrentUserName(),
      //"item-id": itemDocumentReferencer.id, //! Dont think i need this
    };

    await itemDocumentReferencer
        .update(data)
        .whenComplete(() => print("item edited in the database"))
        .catchError((e) => print(e));
  }

//  method to increment item count in database by one (called each time qr code is scanned)
  static Future<void> incrementItemQuantity(String qrCode) async {
    int quantity = 0;
    int newQuantity = 0;
    DateTime now = DateTime.now();
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;

    String formattedDate = DateFormat('MM/dd/yyyy - HH:mm')
        .format(now); // format the date like "11/15/2021 - 16:52"

    String? currentUserUID = _auth.currentUser?.uid;
    DocumentReference itemDocumentReferencer = _storeCollection
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc(
            qrCode); // finds the document associate with the id read by the qr code scanner

    await itemDocumentReferencer.get().then((snapshot) {
      // this is how we get a DocumentSnapshot from a document reference
      quantity = (snapshot.get('quantity'));
      newQuantity = quantity + 1;
    });
    Map<String, dynamic> data = <String, dynamic>{
      "quantity": newQuantity,
      "mostRecentScanIn": formattedDate,
      "LastEmployeeToInteract": await Database().getCurrentUserName()
    };

    await itemDocumentReferencer
        .update(data)
        .whenComplete(() => print("item quantity increemeted in the database"))
        .catchError((e) => print(e));

    // update the data points map array in the graphData collection in the quantity column
    DocumentReference itemDoc = _storeCollection
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc(qrCode)
        .collection('graphData')
        .doc('quantity');

    await itemDoc
        .set({
          "dataPoints": FieldValue.arrayUnion([
            {"quantity": newQuantity, "date": now}
          ])
        }, SetOptions(merge: true))
        .whenComplete(() => print("updated item quantitygraph in the database"))
        .catchError((e) => print(e));
  }

//  method to decrement item count in database by one (called each time qr code is scanned)
  static Future<void> decrementItemQuantity(String qrCode) async {
    double profit = 0;

    int quantity = 0;
    int newQuantity = 0;
    DateTime now = DateTime.now();
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;

    String formattedDate = DateFormat('MM/dd/yyyy - HH:mm')
        .format(now); // format the date like "11/15/2021 - 16:52"

    String? currentUserUID = _auth.currentUser?.uid;
    DocumentReference itemDocumentReferencer = _storeCollection
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc(
            qrCode); // finds the document associate with the id read by the qr code scanner

    await itemDocumentReferencer.get().then((snapshot) {
      // this is how we get a DocumentSnapshot from a document reference
      quantity = (snapshot.get('quantity'));
      profit = (snapshot.get('price')).toDouble();

      if (quantity == 0) {
        newQuantity = 0; // prevents  a negative quantity val
      } else {
        newQuantity = quantity - 1;
      }
    });
    Map<String, dynamic> data = <String, dynamic>{
      "quantity": newQuantity,
      "mostRecentScanOut": formattedDate,
      "LastEmployeeToInteract": await Database().getCurrentUserName()
    };

    await itemDocumentReferencer
        .update(data)
        .whenComplete(() => print("item quantity decremented in the database"))
        .catchError((e) => print(e));

    // update the data points map array in the graphData collection in the quantity column
    DocumentReference itemDoc = _storeCollection
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc(qrCode)
        .collection('graphData')
        .doc('quantity');

    await itemDoc
        .set({
          "dataPoints": FieldValue.arrayUnion([
            {"quantity": newQuantity, "date": now}
          ])
        }, SetOptions(merge: true))
        .whenComplete(() => print("updated item quantitygraph in the database"))
        .catchError((e) => print(e));

    //  update the sales data point for the store
    DocumentReference salesDoc = _storeCollection
        .doc(Database.currentStoreID)
        .collection('storeData')
        .doc('sales');

    await salesDoc
        .set({
          "dataPoints": FieldValue.arrayUnion([
            {"profit": profit.toDouble(), "date": now, "itemID": qrCode}
          ])
        }, SetOptions(merge: true))
        .whenComplete(() => print("updated item salesData in the database"))
        .catchError((e) => print(e));
  }

  //! //////////////////////////////////////////////      HELPER   /////////////////////////////////////////

  static String currentStoreID =
      ""; // making it static means it simply belongs to the class, so I don't have to have an instance of the class to call it in other .dart files (like store-screen)
  static bool isSelected = false;

//  method to get a currentStoreID
  String getCurrentStoreID() {
    return currentStoreID;
  }

//  method to get a currentUserID
  String getCurrentUserID() {
    String currentUserID = _auth.currentUser!.uid;
    return currentUserID;
  }

//method to set a store id
  static setcurrentStoreID(String storeID) {
    currentStoreID = storeID;
  }

//  sets whether store has been clicked
  setStoreClicked(bool val) {
    storeIsClicked = val;
  }

//  gets whether store has been clicked
  getStoreClicked() {
    return storeIsClicked;
  }

//  returns the first and last name of the current user
  Future<String> getCurrentUserName() async {
    String? userFirstName = "";
    String? userLastName = "";

    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    //  this doc ref gets the name of the current user
    DocumentReference userDoc = _userCollection.doc(currentUserID);
    await userDoc.get().then((snapshot) {
      userFirstName = snapshot.get('firstName');
      userLastName = snapshot.get('lastName');
    });

    return userFirstName! + " " + userLastName!;
  }

//  method to get an item's quantity //! not used
  static getItemQuantity(String itemID) async {
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    int quantity = 0;
    DocumentReference itemDoc = _userCollection
        .doc(currentUserID)
        .collection('stores')
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc('itemID');

    await itemDoc.get().then((snapshot) {
      // this is how we get a DocumentSnapshot from a document reference
      quantity = (snapshot.get('quantity'));
      print('the quantity from the getITemQuantity method is ' +
          quantity.toString());
    });
    return quantity;
  }

  //returns line data list
  Future<List<QuantityOverMonth>> getLineData(String itemID) async {
    List<dynamic> list;
    List<QuantityOverMonth> q = [];

    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    //  this doc ref gets the name of the current user
    DocumentReference itemDoc = _userCollection
        .doc(currentUserID)
        .collection('stores')
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc(itemID)
        .collection('graphData')
        .doc('quantity');

    // Map<String, dynamic> data = <String, dynamic>{
    //   "dataPoints": [{"quantity" : Database.getItemQuantity('he'), "date" : DateTime.now()}],
    // };

    // await itemDoc
    //         .update(data)
    //         .whenComplete(() => print("item quantity daily increemeted in the database"))
    //         .catchError((e) => print(e));

    await itemDoc.get().then((snapshot) {
      // get the list from firebase
      list = snapshot.get('dataPoints');
      //print('THIS IS THE LIST:    ');
      //print(list);

      // convert that list to a map

      /* 
      NOTE: Firebase stores DateTime as a timestamp in the form Timestamp(seconds=1639583912, nanoseconds=473000000), so I have to do something like
      below to convert the timestamp back to a DateTime 

      var t = q[0].date   -- (which means something like var t = Timestamp(1639583912, 473000000);)
      print(DateTime.fromMillisecondsSinceEpoch(t.seconds * 1000));

      */
      //print('THIS IS THE MAP and map2:    ');

      // this map just shows how to convert to datetime
      var map = {};
      list.forEach((entry) => map[DateTime.fromMillisecondsSinceEpoch(
              (entry['date']).seconds * 1000)] =
          entry['quantity']
              .toDouble()); // cast the int quantity in database to double
      // print(map);

      //! map2 is just for testing. can be removed eventually
      var map2 = {};
      list.forEach(
          (entry) => map2[(entry['date'].seconds / 1000)] = entry['quantity']);
      // print(map2);

      //take that map and convert it to type QuantityOverMonth
      //   print('THIS IS THE QUANTITY DAILY MAP:    ');

      map.forEach((k, v) => q.add(QuantityOverMonth(k, v)));

      print(
          'THIS IS THE date val in milliseconds in the QUANTITY DAILY MAP in position 1:    ');
      print(q[1].date.millisecondsSinceEpoch.toDouble().toString());
      print(
          'THIS IS THE quantity val in the QUANTITY DAILY MAP in position 1:    ');
      print(q[1].quantity);
    });

    return q;
  }

  //method that returns all quantity datapoints from a specific month

  Future<List<QuantityOverMonth>> getMonthLineData(
      String itemID, int month, int year) async {
    List<dynamic> list;
    List<QuantityOverMonth> q = [];

    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    //  this doc ref gets the name of the current user
    DocumentReference itemDoc = _storeCollection
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc(itemID)
        .collection('graphData')
        .doc('quantity');

    await itemDoc.get().then((snapshot) {
      // get the list from firebase
      list = snapshot.get('dataPoints');

      // from that list, only add entries that match the month passed in as a paremeter to the map
      var map = {};
      list.forEach((entry) {
        if (DateTime.fromMillisecondsSinceEpoch((entry['date']).seconds * 1000)
                    .month
                    .compareTo(month) ==
                0 // compareTo will ret 0 if the month of the entry date matches the month passed in the parameter.
            &&
            DateTime.fromMillisecondsSinceEpoch((entry['date']).seconds * 1000)
                    .year
                    .compareTo(year) ==
                0) {
          map[DateTime.fromMillisecondsSinceEpoch(
              (entry['date']).seconds * 1000)] = entry['quantity'].toDouble();
        }
      });
      // print(map);

      //take that map and convert it to type QuantityOverMonth
      map.forEach((k, v) => q.add(QuantityOverMonth(k, v)));

      print(
          'THIS IS THE MAP FOR  ' + month.toString() + ' / ' + year.toString());

      if (map.isNotEmpty) {
        //! for debugging
        print('THIS IS THE date val in position 0:    ');
        print(q[0].date..toString());
        print('THIS IS THE quantity val  position 0:    ');
        print(q[0].quantity);
      }
    });

    return q;
  }
  //  method to return all data for a specific year
  Future<List<QuantityOverYear>> getYearLineData(
      String itemID, int year) async {
    List<dynamic> list;
    List<QuantityOverYear> q = [];

    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    //  this doc ref gets the name of the current user
    DocumentReference itemDoc = _storeCollection
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc(itemID)
        .collection('graphData')
        .doc('quantity');

    await itemDoc.get().then((snapshot) {
      // get the list from firebase
      list = snapshot.get('dataPoints');

      // from that list, only add entries that match the month passed in as a paremeter to the map
      var map = {};
      list.forEach((entry) {
        if (DateTime.fromMillisecondsSinceEpoch((entry['date']).seconds * 1000)
                .year
                .compareTo(year) ==
            0) {
          map[DateTime.fromMillisecondsSinceEpoch(
              (entry['date']).seconds * 1000)] = entry['quantity'].toDouble();
        }
      });
      // print(map);

      //take that map and convert it to type QuantityOverMonth
      map.forEach((k, v) => q.add(QuantityOverYear(k, v)));

      print('THIS IS THE MAP FOR THE YEAR ' + year.toString());

      if (map.isNotEmpty) {
        //! for debugging
        print('THIS IS THE date val in position 0:    ');
        print(q[0].date..toString());
        print('THIS IS THE quantity val  position 0:    ');
        print(q[0].quantity);
      }
    });

    return q;
  }

// method that returns all quantity datapoints from a specific day
  Future<List<QuantityOverDay>> getDayLineData(
      String itemID, int month, int day, int year) async {
    List<dynamic> list;
    List<QuantityOverDay> q = [];

    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    //  this doc ref gets the name of the current user
    DocumentReference itemDoc = _storeCollection
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc(itemID)
        .collection('graphData')
        .doc('quantity');

    await itemDoc.get().then((snapshot) {
      // get the list from firebase
      list = snapshot.get('dataPoints');

      // from that list, only add entries that match the month and day passed in as a paremeter to the map
      var map = {};
      list.forEach((entry) {
        if (DateTime.fromMillisecondsSinceEpoch((entry['date']).seconds * 1000)
                    .month
                    .compareTo(month) ==
                0 &&
            DateTime.fromMillisecondsSinceEpoch((entry['date']).seconds * 1000)
                    .day
                    .compareTo(day) ==
                0 &&
            DateTime.fromMillisecondsSinceEpoch((entry['date']).seconds * 1000)
                    .year
                    .compareTo(year) ==
                0)
        // compareTo will ret 0 if the month of the entry date matches the month passed in the parameter.
        {
          map[DateTime.fromMillisecondsSinceEpoch(
              (entry['date']).seconds * 1000)] = entry['quantity'].toDouble();
        }
      });
      // print(map);

      //take that map and convert it to type QuantityOverDay
      map.forEach((k, v) => q.add(QuantityOverDay(k, v)));

      print('THIS IS THE MAP FOR THE DATE ' +
          month.toString() +
          " / " +
          day.toString() +
          " / " +
          year.toString());

      if (map.isNotEmpty) {
        //! for debugging
        print('THIS IS THE date val in position 0:    ');
        print(q[0].date..toString());
        print('THIS IS THE quantity val  position 0:    ');
        print(q[0].quantity);
      }
    });

    return q;
  }


// helper method for add user to store
  getUserUIDFromEmail(String email) async {
    Stream<QuerySnapshot<Object?>> userDocumentStream = _userCollection.where('email', isEqualTo: email).snapshots(); 

    QuerySnapshot<Object?> docQuery = await userDocumentStream.first;

    DocumentSnapshot doc = docQuery.docs[0]; // returns the first entry in an array list.

    print('the size of the docQuery is ' + docQuery.size.toString());
    print('the value that should be retd from getUserUIDFromEmail method is ' + doc.get('userID'));


    return doc.get('userID');
  }

// helper method for add user to store
  getUserNameFromEmail(String email) async {
    Stream<QuerySnapshot<Object?>> userDocumentStream = _userCollection.where('email', isEqualTo: email).snapshots(); 

    QuerySnapshot<Object?> docQuery = await userDocumentStream.first;

    DocumentSnapshot doc = docQuery.docs[0]; // returns the first entry in an array list.

    print('the size of the docQuery is ' + docQuery.size.toString());
    print('the value that should be retd from getUserUIDFromEmail method is ' + doc.get('firstName') + " " + doc.get('lastName'));


    return doc.get('firstName') + " " + doc.get('lastName');
  }


  
  Future<double> getStoreTotalProfits() async {
    List<dynamic> list;
    double totalProfits = 0;

    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    //  this doc ref gets the name of the current user
    DocumentReference itemDoc = _userCollection
        .doc(currentUserID)
        .collection('stores')
        .doc(Database().getCurrentStoreID())
        .collection('storeData')
        .doc('sales');

    await itemDoc.get().then((snapshot) {
      // get the list of all sales from firebase
      list = snapshot.get('dataPoints');

      // from that list,  add all entries to map
      list.forEach((entry) {
        totalProfits += entry['profit'].toDouble();
      });
    });
    return totalProfits;
  }

// //This looks at a snapshot of the store and pulls its name out, sending it to a helper method which converts the <Future>String to String
//   Future<String> getSelectedStoreName() async {
//     String? currentUserUID = _auth.currentUser?.uid;
//     String storeName = "null";

//     DocumentReference storeDocumentReferencer = _userCollection
//         .doc(currentUserUID)
//         .collection('stores')
//         .doc(Database().getCurrentStoreID());

//     await storeDocumentReferencer.get().then((snapshot) {
//       // this is how we get a DocumentSnapshot from a document reference
//       storeName = (snapshot.get('name'));
//     });

//     print('THIS is THe STORE NAME ' + storeName);

//     return storeName; //TODO: this is return Future Stirng
//   }

}
