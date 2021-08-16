import 'package:flutter/material.dart';
import 'package:howell_capstone/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth =
      AuthService(); //  allows me to pull from any methods in my auth.dart in services folder.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.purple[400],
          elevation: 0.0,
          title: Text('Sign in to SIM'),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: ElevatedButton(
                child: Text('Sign In Anonymously'),
                style: ElevatedButton.styleFrom(primary: Colors.purple),
                onPressed: () async {
                  // it is dynamic because it could be null or Firebase user
                  dynamic result = await _auth.signinAnonymously();

                  if (result == null) {
                    print('error signing in');
                  } else {
                    print('signed in');
                    print(result);
                  }
                })));
  }
}
