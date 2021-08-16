import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // private property _auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in anonymously
  Future signinAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password

  // register with email and passwords

  // sign out

}
