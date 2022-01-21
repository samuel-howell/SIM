import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:howell_capstone/src/screens/nav-drawer-screen.dart';
import 'package:howell_capstone/theme/theme_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    String? currentUserID = auth.currentUser?.uid;

    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
          //  import my custom navigation sidebar drawer widget and use as the drawer.
          drawer: NavigationDrawerWidget(),
          appBar: AppBar(
            title: Text(themeNotifier.isDark ? "Dark Mode" : "Light Mode"),
            actions: [
              IconButton(
                  icon: Icon(themeNotifier.isDark
                      ? Icons.nightlight_round
                      : Icons.wb_sunny),
                  onPressed: () {
                    themeNotifier.isDark
                        ? themeNotifier.isDark = false
                        : themeNotifier.isDark = true;
                    print("Theme change clicked");
                  })
            ],
          ),
          body: Center(
              child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(
                  margin: EdgeInsets.all(25),
                  child: Text(
                      'This is the home screen. the user id currently active is ' +
                          currentUserID.toString(),
                      style: TextStyle(fontSize: 25))),
            ]),
          )));
    });
  }
}

/* * Color scheme for app could be
 0xff403F4C -dark liver,  
 0xffE84855 -red crayola,  
 0xffF9DC5C -naples yellow,  
 0xff3185FC -azure,  
 0xffEFBCD5 -cameo pink

*/
