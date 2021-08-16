//this Wrapper.dart file either redirects to Home screen or Authentication screen depending on if the user is authenticated

import 'package:flutter/material.dart';
import 'package:howell_capstone/screens/authenticate/authenticate.dart';
import 'package:howell_capstone/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return either Home or Authenitcate widget depending on if the user is signed in
    return Authenticate();
  }
}
