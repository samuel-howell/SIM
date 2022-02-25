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
    required bool isAboveMinimumStockNeeded,
  }) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MM/dd/yyyy - HH:mm')
        .format(now); // format the date like "11/15/2021 - 16:52"

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
      "minimumStockNeeded": 1, // initialize to 1 until user enters a value
      "isAboveMinimumStockNeeded": true,
      "LastEmployeeToInteract": await Database()
          .getCurrentUserName(), //this will be the user id of the last employee to either scan in or scan out the item
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
        .update(
          {
            "sharedWith": FieldValue.arrayUnion([
              await Database().getUserUIDFromEmail(email),
            ])
          },
        )
        .whenComplete(() => print("user added to the store " + docID))
        .catchError((e) => print(e));
  }

//  method to  add a store
  static Future<void> addStore({
    required String name,
    required String address,
  }) async {
    DocumentReference storeDocumentReferencer = _storeCollection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "lowercaseName": name.toLowerCase(),
      "address": address,
      "lowercaseAddress": address.toLowerCase(),
      "storeID": storeDocumentReferencer.id,
      "sharedWith":
          [], // init an array to store all the user uids that can access this particular store
      "createdBy": Database().getCurrentUserID(),
      "totalCurrentStock": 0 // init total store stock to zero
    };

    await storeDocumentReferencer
        .set(data)
        .whenComplete(() => print("Store added to the database"))
        .catchError((e) => print(e));
  }

  //! //////////////////////////////////////////////      DELETE    /////////////////////////////////////////

//  method to delete a store
  static Future<void> deleteStore(String storeDocID) async {


    await _storeCollection.doc(storeDocID).delete();

    print('the delete button was pressed.and the store id was ' +
        storeDocID.toString());
  }

//  method to delete a item
  static Future<void> deleteItem(String itemDocID) async {


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
    String? currentUserUID = _auth.currentUser
        ?.uid; // get the current user id at the moment the method has been triggered
    DocumentReference storeDocumentReferencer = _storeCollection.doc(
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
 // get the current user id at the moment the method has been triggered

    DocumentReference itemDocumentReferencer = _storeCollection
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc(itemDocID);

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
    int currentStock = await Database().getStoreTotalStock(); // gets the current total stock so we can increment it.

    String formattedDate = DateFormat('MM/dd/yyyy - HH:mm')
        .format(now); // format the date like "11/15/2021 - 16:52"

    DocumentReference itemDocumentReferencer = _storeCollection
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc(
            qrCode); // finds the document associate with the id read by the qr code scanner

    DocumentReference storeDocumentReferencer = _storeCollection
        .doc(Database().getCurrentStoreID());

    await itemDocumentReferencer.get().then((snapshot) {
      // this is how we get a DocumentSnapshot from a document reference
      quantity = (snapshot.get('quantity'));
      newQuantity = quantity + 1;
    });
    Map<String, dynamic> data = <String, dynamic>{ // this data goes to item page in db
      "quantity": newQuantity,
      "mostRecentScanIn": formattedDate,
      "LastEmployeeToInteract": await Database().getCurrentUserName()
    };

    Map<String, dynamic> data2 = <String, dynamic>{ // this data goes to store page in db to update overall stock
      "totalCurrentStock": currentStock + 1,
    };

    await itemDocumentReferencer
        .update(data)
        .whenComplete(() => print("item quantity incremented in the database"))
        .catchError((e) => print(e));

    await storeDocumentReferencer
        .update(data2)
        .whenComplete(() => print("overall Store stock incremented in the database"))
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
    int currentStock = await Database().getStoreTotalStock(); // gets the current total stock so we can decrement it.

    int quantity = 0;
    int newQuantity = 0;
    DateTime now = DateTime.now();
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;

    String formattedDate = DateFormat('MM/dd/yyyy - HH:mm')
        .format(now); // format the date like "11/15/2021 - 16:52"

    DocumentReference itemDocumentReferencer = _storeCollection
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc(
            qrCode); // finds the document associate with the id read by the qr code scanner

    DocumentReference storeDocumentReferencer = _storeCollection
        .doc(Database().getCurrentStoreID());

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

    Map<String, dynamic> data2 = <String, dynamic>{ // this data goes to store page in db to update overall stock
      "totalCurrentStock": currentStock - 1,
    };

    await itemDocumentReferencer
        .update(data)
        .whenComplete(() => print("item quantity decremented in the database"))
        .catchError((e) => print(e));
    
    await storeDocumentReferencer
        .update(data2)
        .whenComplete(() => print("overall Store stock incremented in the database"))
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
    print('hit set currentStoreID method');
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


//  returns the name of current store
  Future<String> getCurrentStoreName() async {
    String? name = "";

    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    //  this doc ref gets the name of the current user
    DocumentReference storeDoc = _storeCollection.doc(getCurrentStoreID());
    await storeDoc.get().then((snapshot) {
      name = snapshot.get('name');
    });

    return name!;
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
    Stream<QuerySnapshot<Object?>> userDocumentStream =
        _userCollection.where('email', isEqualTo: email).snapshots();

    QuerySnapshot<Object?> docQuery = await userDocumentStream.first;

    DocumentSnapshot doc =
        docQuery.docs[0]; // returns the first entry in an array list.

    print('the size of the docQuery is ' + docQuery.size.toString());
    print('the value that should be retd from getUserUIDFromEmail method is ' +
        doc.get('userID'));

    return doc.get('userID');
  }

// helper method for add user to store
  getUserNameFromEmail(String email) async {
    Stream<QuerySnapshot<Object?>> userDocumentStream =
        _userCollection.where('email', isEqualTo: email).snapshots();

    QuerySnapshot<Object?> docQuery = await userDocumentStream.first;

    DocumentSnapshot doc =
        docQuery.docs[0]; // returns the first entry in an array list.

    print('the size of the docQuery is ' + docQuery.size.toString());
    print('the value that should be retd from getUserUIDFromEmail method is ' +
        doc.get('firstName') +
        " " +
        doc.get('lastName'));

    return doc.get('firstName') + " " + doc.get('lastName');
  }


  getUserNameFromUID(String uid) async {
    Stream<QuerySnapshot<Object?>> userDocumentStream =
        _userCollection.where('userID', isEqualTo: uid).snapshots();

    QuerySnapshot<Object?> docQuery = await userDocumentStream.first;

    DocumentSnapshot doc =
        docQuery.docs[0]; // returns the first entry in an array list. of which there will only be 1 because we called userDocumentStream.first

    print('the size of the docQuery is ' + docQuery.size.toString());
    print('the value that should be retd from getUserNameFromUID method is ' +
        doc.get('firstName') +
        " " +
        doc.get('lastName'));

    return doc.get('firstName') + " " + doc.get('lastName');
  }

// method to add a new minimum stock needed on an item to store

  static Future<void> setMinimumStockNeeded(
      {required double min, required String itemDocID}) async {
    DocumentReference itemDocumentReferencer = _storeCollection
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc(itemDocID);

    Map<String, dynamic> data = <String, dynamic>{
      "minimumStockNeeded": min,
    };

    await itemDocumentReferencer
        .update(data)
        .whenComplete(() => print("stock minimum updated in database"))
        .catchError((e) => print(e));
  }


// helper method for check stock levels
  static Future<void> isAboveMinimumStockNeeded(
      {required String itemDocID}) async {

    bool flag = false;
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('Stores')
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc(itemDocID)
        .get();

    

    if (doc.get('minimumStockNeeded') <
        doc.get(
            'quantity') || doc.get('minimumStockNeeded') == doc.get('quantity')) //NOTE:  It matters what type minimumStock and quntity are in db
    {
      // we are over stock
      flag = true;
    } else {
       // we are under stock
      flag = false;
    }

    DocumentReference itemDocumentReferencer = _storeCollection
        .doc(Database().getCurrentStoreID())
        .collection('items')
        .doc(itemDocID);

    Map<String, dynamic> data = <String, dynamic>{
      "isAboveMinimumStockNeeded": flag,
    };

    if (doc.get('isAboveMinimumStockNeeded') == true && flag == false) {
      await itemDocumentReferencer
          .update(data)
          .whenComplete(() => print(
              "item was showing good amount of stock, but we were under, so we updated to show we are in the RED"))
          .catchError((e) => print(e));
    } else if (doc.get('isAboveMinimumStockNeeded') == false && flag == true) {
      await itemDocumentReferencer
          .update(data)
          .whenComplete(() => print(
              "item was showing bad amount of stock, but we were over, so we updated to show we are in the GREEN"))
          .catchError((e) => print(e));
    }
  }
  
  //run a check to see what items in selected store are under recommended stock levels
Future<void> checkRecommendedStockLevels() async {
  

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Stores')
      .doc(Database().getCurrentStoreID())
      .collection('items')
      .get();
  for (int i = 0; i < querySnapshot.docs.length; i++) {
    var doc = querySnapshot.docs[i];
    print('checking stock levels for ' + doc.get('name'));

    await Database.isAboveMinimumStockNeeded(itemDocID: doc.id);
  }
}

// helper method to get total store profits
  Future<double> getStoreTotalProfits() async {
    List<dynamic> list;
    double totalProfits = 0;

    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    //  this doc ref gets the name of the current user
    DocumentReference itemDoc = _storeCollection
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

// helper method to get total store stock
  Future<int> getStoreTotalStock() async {
    int totalStock = 0;

    await Database().refreshStoreStockTotal();
   
    DocumentReference storeDoc = _storeCollection
        .doc(Database().getCurrentStoreID());
        
        

    await storeDoc.get().then((snapshot) {
      // get the list of all sales from firebase
      totalStock = snapshot.get('totalCurrentStock');
     
  });
  return totalStock;
  }


//TODO:  Look below for how to track stock total
/* 
we have to query the quantity of each item in the database to refresh total stock value.  

*/
  //tODO modiffy method to scan item quantity of each item in store and return total.  
  refreshStoreStockTotal() async {

    num total = 0;
    Stream<QuerySnapshot<Map<String, dynamic>>> itemStockDocRef = _storeCollection
        .doc(Database().getCurrentStoreID()).collection('items').snapshots();

     itemStockDocRef.forEach((snapshot) async {
       if(snapshot.docs.isNotEmpty){

        for (var doc in snapshot.docs)
         {
          total += doc.get('quantity');
            print('total is now ' + total.toString());

         }
         
         // write the total to the store total stock field 
    Map<String, dynamic> data = <String, dynamic>{ // this data goes to store page in db to update overall stock
      "totalCurrentStock": total,
    };

    DocumentReference storeDocumentReferencer = _storeCollection
        .doc(Database().getCurrentStoreID());

    await storeDocumentReferencer
        .update(data)
        .whenComplete(() => print("storeTotalStock updated in the database from the refreshStoreStockTotal method "))
        .catchError((e) => print(e));
        
        
       }
       else{
         print('documents in refreshStoreStockTotal don\'t exist');
       }
     });
    

    

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
