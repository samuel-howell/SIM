import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:howell_capstone/src/res/custom-colors.dart';
import 'package:howell_capstone/src/utilities/database.dart';

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


//TODO:  figure out a way to delete multiple items at one time from the list
//  this method will show an alert dialog asking user if they really want to delete the store. If yes is clicked, store will be deleted from firebase database
showStoreDeleteConfirmationAlertDialog(BuildContext context, String storeDocID) {  // 
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
      print('the delete button was pressed.');
      db.collection('Users').doc(currentUserUID).collection('stores').doc(storeDocID).delete(); // in firebase, it goes from collection  users -> store -> the doc id of the the store you just tapped, then deletes it

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



// this method will show an alert to enter the information to add a new store to database
showAddStoreDialog(BuildContext context) {

final TextEditingController _storeNameController = TextEditingController();
final TextEditingController _storeAddressController = TextEditingController();
bool _isProcessing = false;

return showDialog(
  context: context,
  builder: (context) {

     return StatefulBuilder(
        builder: (context, setState)  {
          AlertDialog newStoreAlert = AlertDialog(
              title: Text("Add a New Store"),
              content: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        //text field for store name
                        TextFormField(
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter the store\'s name',
                          ),


                          controller: _storeNameController,
                          keyboardType: TextInputType.text,
                        

                          validator: (value) { // The validator receives the text that the user has entered.
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),

                      //text field for store address
                        TextFormField(
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter the store\'s address',
                          ),


                          controller: _storeAddressController,
                          keyboardType: TextInputType.text,
                        

                          validator: (value) { // The validator receives the text that the user has entered.
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                    
                        _isProcessing
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    CustomColors.cblue,
                                  ),
                                ),
                              )
                            : Container(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      CustomColors.cyellow,
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                        _isProcessing = true;
                                    });

                                    await Database.addStore( 
                                      name: _storeNameController.text,
                                      address: _storeAddressController.text,
                                    );
                                    
                                    setState(() {
                                      _isProcessing = false;
                                    });

                                    Navigator.of(context).pop(); // return to previous screen after operation is complete
                                    }
                                  ,
                                  child: const Text('Submit'),
                                ),
                          )
                      ],
                    ),
            ),
                  
          );
          return newStoreAlert; 
        }
      ); 
    }
  );
}


// this method shows an alert to update the store name address
showEditStoreDialog(BuildContext context, String storeDocID) {  // make sure to pull the docID from the store screen ( the store that is clicked on)


final TextEditingController _storeNameController = TextEditingController();
final TextEditingController _storeAddressController = TextEditingController();
bool _isProcessing = false;

return showDialog(
  context: context,
  builder: (context) {

     return StatefulBuilder(
        builder: (context, setState)  {
          AlertDialog editStoreAlert = AlertDialog(
              title: Text("Edit a Current Store"),
              content: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        //text field for store name
                        TextFormField(
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter the store\'s new name',
                          ),


                          controller: _storeNameController,
                          keyboardType: TextInputType.text,
                        

                          validator: (value) { // The validator receives the text that the user has entered.
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),

                      //text field for store address
                        TextFormField(
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter the store\'s new address',
                          ),


                          controller: _storeAddressController,
                          keyboardType: TextInputType.text,
                        

                          validator: (value) { // The validator receives the text that the user has entered.
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                    
                        _isProcessing
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    CustomColors.cblue,
                                  ),
                                ),
                              )
                            : Container(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      CustomColors.cyellow,
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                        _isProcessing = true;
                                    });

                                    await Database.editStore( 
                                      name: _storeNameController.text,
                                      address: _storeAddressController.text,
                                      docID: storeDocID,  // make sure to pass the doc id to the editStore method so you know which store document to update
                                    );
                                    
                                    setState(() {
                                      _isProcessing = false;
                                    });

                                    Navigator.of(context).pop(); // return to previous screen after operation is complete
                                    }
                                  ,
                                  child: const Text('Submit'),
                                ),
                          )
                      ],
                    ),
            ),
                  
          );
          return editStoreAlert; 
        }
      ); 
    }
  );
}





//TODO:  figure out a way to delete multiple items at one time from the list
//  this method will delete the item from the item list
showItemDeleteConfirmationAlertDialog(BuildContext context, String itemDocID) {  // 
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
      print('the delete button was pressed.');
      db.collection('Users').doc(currentUserUID).collection('stores').doc(Database().getCurrentStoreID()).collection('items').doc(itemDocID).delete(); // in firebase, it goes from collection  users -> store -> the doc id of the the store you just tapped, then deletes it

      Navigator.of(context).pop(); // removes the dialog from the screen
      Fluttertoast.showToast(msg: 'You deleted the item!', gravity: ToastGravity.TOP); // shows a toast message confirming store deletion
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Item Deletion Confirmation"),
    content: Text("Are you sure you would like to delete the selected item?"),
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


// this method shows an alert to update the item information
showEditItemDialog(BuildContext context, String itemDocID) {  // make sure to pull the docID from the item screen ( the item that is clicked on)


final TextEditingController _itemNameController = TextEditingController();
final TextEditingController _itemDescriptionController = TextEditingController();
final TextEditingController _itemQuantityController = TextEditingController();
final TextEditingController _itemPriceController = TextEditingController();
bool _isProcessing = false;

return showDialog(
  context: context,
  builder: (context) {

     return StatefulBuilder(
        builder: (context, setState)  {
          AlertDialog editStoreAlert = AlertDialog(
              title: Text("Edit a Current Item"),
              content: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        //text field for item name
                        TextFormField(
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter the item\'s new name',
                          ),


                          controller: _itemNameController,
                          keyboardType: TextInputType.text,
                        

                          validator: (value) { // The validator receives the text that the user has entered.
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),

                      //text field for item description
                        TextFormField(
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter the item\'s new description',
                          ),


                          controller: _itemDescriptionController,
                          keyboardType: TextInputType.text,
                        

                          validator: (value) { // The validator receives the text that the user has entered.
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),


                        //text field for item price
                        TextFormField(
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter the item\'s new price',
                          ),


                          controller: _itemPriceController,
                          keyboardType: TextInputType.number,
                        

                          validator: (value) { // The validator receives the text that the user has entered.
                            if (value == null || value.isEmpty) {
                              return 'Please enter some numbers';
                            }
                            return null;
                          },
                        ),

                        //text field for item quantity
                        TextFormField(
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter the item\'s new quantity',
                          ),


                          controller: _itemQuantityController,
                          keyboardType: TextInputType.number,
                        

                          validator: (value) { // The validator receives the text that the user has entered.
                            if (value == null || value.isEmpty) {
                              return 'Please enter some numbers';
                            }
                            return null;
                          },
                        ),
                    
                        _isProcessing
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    CustomColors.cblue,
                                  ),
                                ),
                              )
                            : Container(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      CustomColors.cyellow,
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                        _isProcessing = true;
                                    });

                                    await Database.editItem( 
                                      name: _itemNameController.text,
                                      description: _itemDescriptionController.text, 
                                      itemDocID: itemDocID, //! make sure this is the item docId
                                      price: _itemPriceController.text, 
                                      quantity: _itemQuantityController.text,  // make sure to pass the doc id to the editItem method so you know which store document to update
                                    );
                                    
                                    setState(() {
                                      _isProcessing = false;
                                    });

                                    Navigator.of(context).pop(); // return to previous screen after operation is complete
                                    }
                                  ,
                                  child: const Text('Submit'),
                                ),
                          )
                      ],
                    ),
            ),
                  
          );
          return editStoreAlert; 
        }
      ); 
    }
  );
}










