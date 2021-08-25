import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:howell_capstone/src/screens/home-screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( title: Text('Login'),),
        body: Column(
          
          children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                // defaults the @ symbol on keyboard
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'Email'),
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                }
                ),
          ),



          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                //obscures the pw text
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
                onChanged: (value) {
                  setState(() {
                    _password = value.trim();
                  });
                }),
          ),


          Row(
              // mainaxis alignment puts space around the row
              mainAxisAlignment: MainAxisAlignment.spaceAround,


              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.purple),
                    child: Text('Sign In'),
                    //when pressed, pass email and password to _signin function
                    onPressed: () => _signin(_email, _password)),



                ElevatedButton(
                    //physical colors and such of button
                    style: ElevatedButton.styleFrom(primary: Colors.purple),
                    //  text of button
                    child: Text('Sign Up'),
                    //  what button does when it is pressed. goes to signup function
                    onPressed: () => _signup(_email, _password))
              ])
        ]));
  }

  _signin(String _email, String _password) async {
    try{
      await auth.signInWithEmailAndPassword(email: _email, password: _password);

      //Success
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    } 
    
    //INFO: Fluttertoast will put pop up messages on the screen if auth encounters an error
    on FirebaseAuthException catch (error){
      if (error.code == 'user-not-found'){
          Fluttertoast.showToast(msg: 'No user exists with this email', gravity: ToastGravity.TOP);
      }
      else if (error.code == 'wrong-password'){
          Fluttertoast.showToast(msg: 'Incorrect Password', gravity: ToastGravity.TOP);
      }
      else if (error.code == 'invalid-email'){
          Fluttertoast.showToast(msg: 'Provided email address was not valid', gravity: ToastGravity.TOP);
      }
      else {
          Fluttertoast.showToast(msg: 'ERROR', gravity: ToastGravity.TOP);
      }
    }
  }


   _signup(String _email, String _password) async {
    try{
      await auth.createUserWithEmailAndPassword(email: _email, password: _password);

      //Success
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (error){
      if (error.code == 'weak-password'){
          Fluttertoast.showToast(msg: 'Password needs to be at least 8 characters', gravity: ToastGravity.TOP);
      }
      else if (error.code == 'email-already-in-use'){
          Fluttertoast.showToast(msg: 'This email is already associated with an account', gravity: ToastGravity.TOP);
      }
      else if (error.code == 'invalid-email'){
          Fluttertoast.showToast(msg: 'Provided email address was not valid', gravity: ToastGravity.TOP);
      }
      else {
          Fluttertoast.showToast(msg: 'ERROR', gravity: ToastGravity.TOP);
      }
    }
  }
}


//TODO: https://firebase.google.com/docs/reference/js/firebase.auth.Auth#signInWithEmailAndPassword
// make switch statements with all of these Firebase Auth error messages


