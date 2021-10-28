import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:howell_capstone/src/screens/login-screen.dart';
import 'package:howell_capstone/src/utilities/constants.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final auth = FirebaseAuth.instance;
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Reset Password Screen'),
            centerTitle: true,
            backgroundColor: Colors.black),
        body: Center(
          child: Column(
            children: [
              Text('Enter the email associated with your account below',
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.grey, fontSize: 26))),
              _buildEmailTF(),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xFF73AEF5)),
                  child: Text('Send Password Reset'),
                  //when pressed, pass email and password to _signin function
                  onPressed: () async {
                    try {
                      print('the email is ' + _email);
                      await auth.sendPasswordResetEmail(email: _email);
                    } on FirebaseAuthException catch (error) {
                      print(
                          'an error was encountered with the forgot password function ');
                      print(error.code);
                    }
                  }),
              Text(
                  'Been a few minutes and you didn\'t get the email? Click the button below to resend.',
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.grey, fontSize: 16))),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xFF73AEF5)),
                  child: Text(
                      'Resend Password Reset Email'), //TODO: build out a way to resend the verification email here.
                  //when pressed, pass email and password to _signin function
                  onPressed: () async {
                    try {
                      print('the email is ' + _email);
                      await auth.sendPasswordResetEmail(email: _email);
                    } on FirebaseAuthException catch (error) {
                      print(
                          'an error was encountered with the forgot password function ');
                      print(error.code);
                    }
                  })
            ],
          ),
        ));
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              setState(() {
                _email = value.trim(); // the email string
              });
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}
