import 'package:flutter/material.dart';
import 'package:howell_capstone/src/screens/home-screen.dart';
import 'package:howell_capstone/src/screens/login-screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIM',
      theme: ThemeData(accentColor: Colors.purple, primarySwatch: Colors.blue),

       home: LoginScreen(),  

  
    );
  }
}
