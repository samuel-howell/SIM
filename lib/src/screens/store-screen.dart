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

//hovercolor for web on store list
final hoverColor = Colors.blue;

//  this var will store the index of the store that is currently highlighted in the Listview.builder 
var tappedIndex;



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


      //TODO: Right now, if I log out and then log in as a different user, i have to reload the page before the newly logged in user's set of stores pops up.
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('Users').doc(currentUserUID).collection('stores').snapshots(), // navigate to the correct collection and then call “.snapshots()” at the end. This stream will grab all relevant documents found under that collection to be handled inside our “builder” property.
        builder: (context,  snapshot) { 
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
          return ListView.builder(
            itemCount:snapshot.data!.docs.length,
            itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                

                // the slideable widget allows us to use slide ios animation to bring up delete and edit dialogs
                return Slidable(  
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: ListTile(

                    tileColor:  tappedIndex == index ? Colors.greenAccent : null,   // if the tappedIndex is the index of the list tile, adda  green accent to it, otherwise do nothing
                    hoverColor: hoverColor,  //  adds some extra pizzazz if you're viewing it on the web
                    title:  Text(doc.get('name')),
                    subtitle:Text(doc.get('address')),
                    onTap: () {
                      Database.setcurrentStoreID(doc.id); 

                      setState(() {
                        tappedIndex = index;  //by changing the index of this list tile to the tapped index, we know to put a green accent around only this list tile
                         }
                        );

                      //print out to console what the current store id, index, and list length and tapped index is.
                      print('the getCurrentStoreID is ' + Database().getCurrentStoreID());
                      print('the current user id is ' + _auth.currentUser!.uid.toString());
                      print('item index  is ' + index.toString()); 
                      print('list length  is ' + snapshot.data!.docs.length.toString()); 
                      print('tapped index is '  + tappedIndex.toString()); 


                      print(" ");
                    }
                  ),
                    actions: <Widget>[  // NOTE: using "secondaryActions" as opposed to "actions" allows us to slide in from the right instead of the left"
                    
                    // slide action to delete
                    IconSlideAction
                    (
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete_sharp,
                        onTap: () => {
                          showStoreDeleteConfirmationAlertDialog(context, doc.id),
                          print('store ' + doc.id + ' was deleted.')
                        }
                    ),

                    // slide action to edit
                    IconSlideAction
                    (
                        caption: 'Edit',
                        color: CustomColors.cblue,
                        icon: Icons.edit,  
                        onTap: () => {
                          showEditStoreDialog(context, doc.id),
                          print('store ' + doc.id + ' was edited')
                        }
                    ),
                    ]
                );
               }
            );
            }
      ),

    floatingActionButton: FloatingActionButton(  
      child: Icon(Icons.post_add),  
      backgroundColor: Colors.green,  
      foregroundColor: Colors.white,  
      onPressed: () => {
        showAddStoreDialog(context),
      },  
  
      ),
      );  
  }
}