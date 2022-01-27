import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:howell_capstone/src/screens/login-screen.dart';
import 'package:howell_capstone/src/screens/tos-screen.dart';
import 'package:howell_capstone/src/utilities/constants.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:howell_capstone/src/widgets/sign-up-form.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

bool termsAccepted = false;
class _SignUpScreenState extends State<SignUpScreen> {


  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //     appBar: AppBar(
    //       title: Text('Sign Up Form'),
    //       centerTitle: true,
    //       backgroundColor: Colors.black,
    //       elevation: 0,
    //     ),
    //     body: Container(
    //         margin: EdgeInsets.symmetric(horizontal: 20),
    //         child: Column(children: [
    //           SizedBox(
    //             height: 30,
    //           ),
    //           Text('Sign Up Form', textAlign: TextAlign.center),
    //           SizedBox(
    //             height: 70,
    //           ),
    //           SignUpForm(),
    //         ])));

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 220,
            ),
            Padding(
              padding: kDefaultPadding,
              child: Text(
                'Create Account',
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 32, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: kDefaultPadding,
              child: Row(
                children: [
                  Text(
                    'Already a member?',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(.7), fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      'Log In',
                       style: TextStyle( color: Theme.of(context).colorScheme.secondary, decoration: TextDecoration.underline, decorationThickness: 1),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: kDefaultPadding,
              child: SignUpForm(),
            ),
            SizedBox(
              height: 20,
            ),
           
            SizedBox(
              height: 20,
            ),
          
            // Padding(
            //   padding: kDefaultPadding,
            //   child: PrimaryButton(buttonText: 'Sign Up'),
            // ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  

  }


   
