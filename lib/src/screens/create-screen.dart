import 'package:flutter/material.dart';
import 'package:howell_capstone/src/res/custom-colors.dart';



class CreateScreen extends StatelessWidget {

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Screen'),
        centerTitle: true,
        backgroundColor: Colors.black
      )
    );
  }
}
//TODO: createa form on this page to take in info to put into the firestore database. modify what is in this video to work with the form https://www.youtube.com/watch?v=lyZQa7hqoVY 