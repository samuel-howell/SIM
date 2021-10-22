import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:howell_capstone/src/screens/home-screen.dart';
import 'package:howell_capstone/src/screens/sign-up-screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:howell_capstone/src/utilities/constants.dart';
import 'package:howell_capstone/src/widgets/sign-up-form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

  Widget _buildForgotPasswordBtn() {  //TODO:  figure out a way to implement this
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  

  // Widget _buildSignInWithText() {
  //   return Column(
  //     children: <Widget>[
  //       Text(
  //         '- OR -',
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontWeight: FontWeight.w400,
  //         ),
  //       ),
  //       SizedBox(height: 20.0),
  //       Text(
  //         'Sign in with',
  //         style: kLabelStyle,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildSocialBtn(Function onTap, AssetImage logo) {
  //   return GestureDetector(
  //     onTap: (){print("social button was clicked");},
  //     child: Container(
  //       height: 60.0,
  //       width: 60.0,
  //       decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         color: Colors.white,
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black26,
  //             offset: Offset(0, 2),
  //             blurRadius: 6.0,
  //           ),
  //         ],
  //         image: DecorationImage(
  //           image: logo,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildSocialBtnRow() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 30.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: <Widget>[
  //         _buildSocialBtn(
  //           () => print('Login with Facebook'),
  //           AssetImage(
  //             'assets/logos/facebook.jpg',
  //           ),
  //         ),
  //         _buildSocialBtn(
  //           () => print('Login with Google'),
  //           AssetImage(
  //             'assets/logos/google.jpg',
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }



class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';

  bool _rememberMe = false;

  Widget _buildRememberMeCheckbox() { //TODO:  figure out a way to implement this
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,    /// the _rememberMe boolean
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (bool? value) {
                setState(() {
                  _rememberMe = true;
                  print('_rememberMe is true now.');
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            onChanged: (value) {
                  setState(() {
                    _password = value.trim(); // the password string
                  });
                },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
                  setState(() {
                    _email = value.trim();   // the email string
                  });
                },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
 
  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xFF73AEF5)),
                    child: Text('Sign In'),
                    //when pressed, pass email and password to _signin function
                    onPressed: () async {

                      //  shared pref allows user to remain logged in.  as long as this email is not null, the user will remain signed in
                      if(_rememberMe == true){
                        final SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                        sharedPreferences.setString('email', _email);
                      }

                      _signin(_email, _password); // pass email and password to _signin in function

                    }
                    )
                    );
  }

    Widget _newbuildSignupBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xFF73AEF5)),
                    child: Text('Sign Up'),
                    //when pressed, pass email and password to _signin function
                    onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                                )
                              );                 
          }
                    )
                    );
  }
 
 //TODO: fixt gesture detector not responding
   Widget _buildSignupBtn() { //  TODO:  Take thisto another page, where you ask for name, email, password, etc.
    return GestureDetector(
      onTap: () => SignUpForm(),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Upppp',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildEmailTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      _buildForgotPasswordBtn(),
                      _buildRememberMeCheckbox(),
                      _buildLoginBtn(),
                      _newbuildSignupBtn(),
                      //_buildSignInWithText(), //! get rid of this if your not going to use it
                      //_buildSocialBtnRow(), //! get rid of this if your not going to use it
                      _buildSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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

//ask the user to accept permissions upon initial login

}


//TODO: https://firebase.google.com/docs/reference/js/firebase.auth.Auth#signInWithEmailAndPassword   make switch statements with all of these Firebase Auth error messages



//TODO: https://github.com/MarcusNg/flutter_login_ui/blob/master/lib/screens/login_screen.dart   implement this formatting