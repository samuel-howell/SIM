import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:howell_capstone/src/res/custom-colors.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:howell_capstone/src/widgets/add-item-form.dart';
import 'package:howell_capstone/src/widgets/custom-alert-dialogs.dart';

import 'add-item-screen.dart';


//  gets the current user id
final FirebaseAuth _auth = FirebaseAuth.instance;
final currentUserUID = _auth.currentUser?.uid;

//accesses the firebase database
final db = FirebaseFirestore.instance;

//hovercolor for web on store list
final hoverColor = Colors.indigo[50];

//  this var will store the index of the store that is currently highlighted in the Listview.builder 
var tappedIndex;



class ItemScreen extends StatefulWidget {

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: Text('Item Screen'),
        centerTitle: true,
        backgroundColor: Colors.black
      ),


      //!KNOWN ISSUES
      //TODO: if I don't select a store before I navigate to this item screen, the page crashes
      //TODO: Right now, if I log out and then log in as a different user, i have to reload the page before the newly logged in user's set of items pops up.
      
      body: 
      StreamBuilder<QuerySnapshot>(
        stream: db.collection('Users').doc(currentUserUID).collection('stores').doc(Database().getCurrentStoreID()).collection('items').snapshots(), // navigate to the correct collection and then call “.snapshots()” at the end. This stream will grab all relevant documents found under that collection to be handled inside our “builder” property.
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
                    subtitle:Text(doc.get('description')),
                    onTap: () {
                      //TODO: open a new page and populate it with all item details from firebase 
                      
                        

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
                          showItemDeleteConfirmationAlertDialog(context, doc.id),
                          print('item ' + doc.id + ' was deleted.')
                        }
                    ),

                    // slide action to edit
                    IconSlideAction
                    (
                        caption: 'Edit',
                        color: CustomColors.cblue,
                        icon: Icons.edit,  
                        onTap: () => {
                          showEditItemDialog(context, doc.id),
                          print('item ' + doc.id + ' was edited')
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
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddItemScreen(),
            )
          )//
      },  
  
      ),
      );  
  }
}















//! Old working code

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:howell_capstone/src/res/custom-colors.dart';
// import 'package:howell_capstone/src/widgets/add-item-form.dart';



// class ItemScreen extends StatefulWidget {
// @override
// _ItemScreenState createState() => _ItemScreenState();
// }

// class _ItemScreenState extends State<ItemScreen>{
  
// Map data = {}; 




//    @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create Screen'),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation:0,
//       ),

//       body: Container(
//         margin: EdgeInsets.symmetric(horizontal:20),
//         child: Column(
//           children: [
//             SizedBox(height:30,),
//             Text('Create Screen', textAlign: TextAlign.center),

//             SizedBox(height:70,),

//             AddItemForm(), 
    
//           ]
       
//         )
//       )
//     );
//   }
// }

// //* Good reference articles... https://medium.com/firebase-tips-tricks/how-to-use-cloud-firestore-in-flutter-9ea80593ca40 ... https://www.youtube.com/watch?v=lyZQa7hqoVY 

// //TODO Gihub Reference - https://github.com/sbis04/flutterfire-samples/tree/crud-firestore/lib 