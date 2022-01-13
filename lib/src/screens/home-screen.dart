import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:howell_capstone/src/screens/login-screen.dart';
import 'package:howell_capstone/src/screens/nav-drawer-screen.dart';
import 'package:howell_capstone/src/utilities/database.dart';

import 'package:howell_capstone/src/widgets/line-chart-month/line-chart-widget-month.dart';
import 'package:howell_capstone/src/widgets/line-chart-month/line-data-month.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String? currentUserID = auth.currentUser?.uid;

    return Scaffold(
        //  import my custom navigation sidebar drawer widget and use as the drawer.
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(title: Text("Home")),
        body: Center(
            child: SingleChildScrollView(
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
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text('Quantity Graph', textAlign: TextAlign.center),
                  SizedBox(
                    height: 70,
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                          'placeholder')), /*
                */ //TODO: works on login, but _values go away on page reload.  perhps something to do with preparing the data in init state? I know that I can't call prepare date in the build method or it will cause repeats.  Most likely, this will resolve when I link the graphs to individual item pages.
                ])),
            Container(
                margin: EdgeInsets.all(25),
                child: TextButton(
                    child: Text(
                      'test',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () async {
                      //List data = await Database().getLineData();
                      //List<FLSpot> values
                    }))
          ]),
        )));
  }
}

/* * Color scheme for app could be
 0xff403F4C -dark liver,  
 0xffE84855 -red crayola,  
 0xffF9DC5C -naples yellow,  
 0xff3185FC -azure,  
 0xffEFBCD5 -cameo pink

*/
