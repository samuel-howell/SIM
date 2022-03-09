import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:howell_capstone/src/screens/nav-drawer-screen.dart';

class PleaseChooseStoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(),
        body: Center(
          child: Text('You must first select a store to access this page.',
              style: GoogleFonts.lato(
                  textStyle: TextStyle(color: Colors.grey, fontSize: 26))),
        ));
  }
}
