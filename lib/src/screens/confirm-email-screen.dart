import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:howell_capstone/src/screens/login-screen.dart';

class ConfirmEmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Confirm Email Screen'),
            centerTitle: true,
            backgroundColor: Colors.black),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 200, width: 200), // for frormatting
              Text(
                  'Email confirmation has been sent to your email address. After you accept, please click the button below',
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.grey, fontSize: 26))),

              SizedBox(height: 100, width: 100), //for formatting

              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xFF73AEF5)),
                  child: Text('Sign In'),
                  //when pressed, pass email and password to _signin function
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
                  }),

              SizedBox(height: 200, width: 200), // for frormatting
              Text('Didn\'t get the email? Click the button below to resend',
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.grey, fontSize: 16))),

              SizedBox(height: 100, width: 100), //for formatting

              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xFF73AEF5)),
                  child: Text(
                      'Resend Verification Email'), //TODO: build out a way to resend the verification email here.
                  //when pressed, pass email and password to _signin function
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
                  })
            ],
          ),
        ));
  }
}

//TODO: figure out a good google font for the entire project
