import 'package:flutter/material.dart';
import 'package:howell_capstone/screens/login_screen.dart';
import 'package:howell_capstone/screens/register_screen.dart';
import 'package:howell_capstone/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:howell_capstone/services/auth.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        )
      ],
      child: MaterialApp(
          title: 'SIM',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => Wrapper(),
            '/login': (context) => LoginScreen(),
            '/register': (context) => RegisterScreen(),
          }),
    );
  }
}
