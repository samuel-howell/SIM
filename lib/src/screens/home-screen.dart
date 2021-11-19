import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:howell_capstone/src/screens/login-screen.dart';
import 'package:howell_capstone/src/screens/nav-drawer-screen.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;

//! may need to remove this store list. it isn't doing anyhting. replace with a tile that shows overall store stats
  Stream<QuerySnapshot> storeListQuery = FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUserUID)
      .collection('stores')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    String? currentUserID = auth.currentUser?.uid;

    return Scaffold(
      //  import my custom navigation sidebar drawer widget and use as the drawer.
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(title: Text("Home")),
      body: Center(
          child: Column(children: <Widget>[
        StreamBuilder<QuerySnapshot>(
            stream: storeListQuery,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Center(
                    child: Column(children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(25),
                      child: Text(
                          'This is the home screen. the user id currently active is ' +
                              currentUserID.toString(),
                          style: TextStyle(fontSize: 25))),
                  Container(
                    margin: EdgeInsets.all(25),
                    child: TextButton(
                      child: Text(
                        'Sign Out',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      onPressed: () async {
                        //  removes anything in shared pref forcing the user to relogin next time
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.remove('email');

                        Database().setStoreClicked(
                            false); // sets the isStoreClicked to false so user has to choose a new store next time they login

                        auth.signOut();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                    ),
                  ),
                ]));
              }
            })
      ])),
    );
  }
}

/* * Color scheme for app could be
 0xff403F4C -dark liver,  
 0xffE84855 -red crayola,  
 0xffF9DC5C -naples yellow,  
 0xff3185FC -azure,  
 0xffEFBCD5 -cameo pink

*/
