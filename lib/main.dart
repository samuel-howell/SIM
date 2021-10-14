import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:howell_capstone/src/screens/home-screen.dart';
import 'package:howell_capstone/src/screens/login-screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // app will not run with firebase unless it is initialized
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  print('Shared Preferences shows that the current email is ' + email.toString());
  //runApp(App());
  runApp(MaterialApp(
    title: 'SIM',
    home: email == null ? LoginScreen() : HomeScreen())
    );

}