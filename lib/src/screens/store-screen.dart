import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:howell_capstone/src/res/custom-colors.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:howell_capstone/src/widgets/custom-alert-dialogs.dart';


//  gets the current user id
final FirebaseAuth _auth = FirebaseAuth.instance;
final currentUserUID = _auth.currentUser?.uid;

//accesses the firebase database
final db = FirebaseFirestore.instance;



//TODONOTE: !!!!!!!  ITEMS need to be placed under store id in the firebase database. it need s to go like user --> store-->item

class StoreScreen extends StatefulWidget {

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
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
                return Slidable( //TODO: Figure Out how to slide in from the right  
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: ListTile(
                    title: Text(doc.get('name')),
                    subtitle: Text(doc.get('address')),
                    onTap: () {
                      Database.setcurrentStoreID(doc.id); 
                      
                      //print out to show what the current store id is.
                      print('the getCurrentStoreID is ' + Database().getCurrentStoreID());
                      print(" ");
                    }
                  ),
                    actions: <Widget>[
                    
                    // slide action to delete
                    IconSlideAction
                    (
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete_sharp,
                        onTap: () => {
                          showStoreDeleteConfirmationAlertDialog(context, doc.id),
                        }
                    ),

                    // slide action to edit
                    IconSlideAction
                    (
                        caption: 'Edit',
                        color: CustomColors.cblue,
                        icon: Icons.pageview,  //TODO: find a more appropriate icon
                        onTap: () => {
                          //TODO: add a alert dialog to edit the name and the address of the store.  Perhaps pull from the create store dialog???.
                          
                        }
                    ),
                    ]
                );
               }
              ).toList(),
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