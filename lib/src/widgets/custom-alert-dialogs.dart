import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StoreDeleteConfirmationDialog extends StatelessWidget {
  const StoreDeleteConfirmationDialog({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

final db = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final currentUserUID = _auth.currentUser?.uid;



//  this method will show an alert dialog asking user if they really want to delete the store. If yes is clicked, store will be deleted from firebase database
showStoreDeleteConfirmationAlertDialog(BuildContext context, String docID) {  // 
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("No"),
    onPressed:  () {
      print('the cancel button was pressed');
      Navigator.of(context).pop(); // removes the dialog from the screen
    },
  );
  Widget continueButton = TextButton(
    child: Text("Yes"),
    onPressed:  () {
      print('the continue button was pressed.');
      db.collection('Users').doc(currentUserUID).collection('stores').doc(docID).delete(); // in firebase, it goes from collection  users -> store -> the doc id of the the store you just tapped, then deletes it

      Navigator.of(context).pop(); // removes the dialog from the screen
      Fluttertoast.showToast(msg: 'You deleted the store!', gravity: ToastGravity.TOP); // shows a toast message confirming store deletion
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Store Deletion Confirmation"),
    content: Text("Are you sure you would like to delete the selected store?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}