import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:howell_capstone/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // app will not run with firebase unless it is initialized
  await Firebase.initializeApp();
  runApp(App());
}
