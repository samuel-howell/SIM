import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:howell_capstone/src/screens/login-screen.dart';
import 'package:howell_capstone/src/screens/nav-drawer-screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  import my custom navigation sidebar drawer widget and use as the drawer.
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(title: Text("Home")),
      body: Center(
          child: Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 200),
          child: TextButton(
            child: Text(
              'Hello.  this is page 1',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {},
          ),
        ),
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

              auth.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ),
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
