import 'package:flutter/material.dart';
import 'package:howell_capstone/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';

// test
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase
      .initializeApp(); // app will not run with firebase unless it is initialized
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Wrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}
