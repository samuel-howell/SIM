import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howell_capstone/src/res/custom-colors.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

//  gets the current user id
final FirebaseAuth _auth = FirebaseAuth.instance;
final currentUserUID = _auth.currentUser?.uid;


//TODONOTE: !!!!!!!  ITEMS need to be placed under store id in the firebase database. it need s to go like user --> store-->item

class StoreScreen extends StatefulWidget {

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store Screen'),
        centerTitle: true,
        backgroundColor: Colors.black
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('Users').doc(currentUserUID).collection('stores').snapshots(), // navigate to the correct collection and then call “.snapshots()” at the end. This stream will grab all relevant documents found under that collection to be handled inside our “builder” property.
        builder: (context,  snapshot) { 
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return Card(
                  child: ListTile(
                    isThreeLine: true,
                    title: Text(doc.get('name')),
                    subtitle: Text(doc.get('address')),
                    onTap: () {
                      //TODO: Set this store id to be the current store id and pass it to the database.dart


                      //Database().setcurrentStoreID(doc.id);
                      Database().setcurrentStoreID(doc.id);

                      //! getCurrentStoreID works, but the setter still doesn't work in the database.dart file
                      print('the getCurrentStoreID is ' + Database().getCurrentStoreID());
                      print('the current doc.id is ' + doc.id);
                      print(" ");
                    }
                  )
                );
              }).toList(),
            );
        },
      ),

    floatingActionButton: FloatingActionButton(  
      child: Icon(Icons.post_add),  
      backgroundColor: Colors.green,  
      foregroundColor: Colors.white,  
      onPressed: () => {
      _addStoreDialog(context)
      },  
  
      ),  
    );
  }
}





final TextEditingController _storeNameController = TextEditingController();
final TextEditingController _storeAddressController = TextEditingController();

bool _isProcessing = false;


//TODO: Migrate this _addStoreDialog widget to the widgets folder, then import it into this page. kind of like you diud with the add item form. for refactoring.
//this alert dialog will pop up when the user clicks the "add database" floating action button
Future<void> _addStoreDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState)  {
        return AlertDialog(
          title: const Text('Add a new Store'),
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
          )
      );
    }  
  );
  }
);
}



  //TODO: for reference on alert dialog - https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/