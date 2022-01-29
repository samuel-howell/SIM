import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:howell_capstone/src/screens/login-screen.dart';
import 'package:howell_capstone/src/screens/tos-screen.dart';
import 'package:howell_capstone/src/utilities/constants.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:howell_capstone/src/widgets/sign-up-form.dart';
import 'package:howell_capstone/theme/theme_model.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

bool termsAccepted = false;
class _SignUpScreenState extends State<SignUpScreen> {


  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider(
       create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
      builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               SizedBox(height: 120),
                Padding(
                  padding: kDefaultPadding,
                  child: Image(image: themeNotifier.isDark ? AssetImage('assets/SIMPL-dark.png') : AssetImage('assets/SIMPL-light.png')),
                ), // based on whether theme is dark or light, we show the logo with appropriate coloring
               SizedBox(height: 80),

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
                         style: TextStyle( color: Theme.of(context).colorScheme.primaryVariant, decoration: TextDecoration.underline, decorationThickness: 1),
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
          )   
    );
          
  }

  

  }


   
