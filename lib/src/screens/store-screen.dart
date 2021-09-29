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
final hoverColor = Colors.indigo[50];

//  this var will store the index of the store that is currently highlighted in the Listview.builder 
var tappedIndex;

// the editing controller to control the search bar
final TextEditingController searchController = TextEditingController();

String searchKey = "";
Stream<QuerySnapshot> streamQuery = db.collection('Users').doc(currentUserUID).collection('stores').snapshots();


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
      body:
             
      StreamBuilder<QuerySnapshot>(
        stream: streamQuery,
        builder: (context,  snapshot) { 

          


          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } 

         
          else{
            return Container(
            child: Column(
              children: <Widget>[

                //TODO:  migrate this code over to the item page
                //this search bar filters out stores
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                          searchKey = value; // TODO: set this toLowercase once you have implemented the todo below

                          //  this stream query matches the searchkey to the names of the stores in the db
                          streamQuery = db.collection('Users').doc(currentUserUID).collection('stores')
                          .where('name',isGreaterThanOrEqualTo: searchKey) //TODO:create a new field each store doc called lowercaseName that stores a LOWERCASE version of whatever the user enters as the name.  then search against lowerCaseName rather than name
                          .where('name',isLessThan: searchKey+'z').snapshots();

                          //TODO:  need to be able to search by name and address. there are no OR queries in firebase though. FIGURE OUT HOW TO DO AN 'OR' QUERY
                          //TODO: on the item page, will need to be able to search by price, name, product id, etc.  Perhaps a dropdown search that lets you specify wwhat you're searchin for?
                      });
                    },
                    decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),


                Expanded(  // if I don't have Expanded here, the listview won't be sized in relation to hte searchbar textfield, thus throwing errors
              child: ListView.builder(
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
              
                )
                )
              ]
              )
              );
         }
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


