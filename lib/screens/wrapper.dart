//this Wrapper.dart file either redirects to Home screen or Authentication screen depending on if the user is authenticated

import 'package:flutter/material.dart';
import 'package:howell_capstone/screens/home_screen.dart';
import 'package:howell_capstone/screens/login_screen.dart';
import 'package:howell_capstone/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:howell_capstone/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;

          return user == null
              ? LoginScreen()
              : HomeScreen(); //  return login screen or home screen depending on if the user exists
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
