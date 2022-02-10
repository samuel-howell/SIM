import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:howell_capstone/src/screens/confirm-email-screen.dart';
import 'package:howell_capstone/src/screens/home-screen.dart';
import 'package:howell_capstone/src/screens/password-reset-screen.dart';
import 'package:howell_capstone/src/screens/please-choose-store-screen.dart';
import 'package:howell_capstone/src/screens/sign-up-screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
 import 'package:howell_capstone/src/screens/store-screen-createdBy.dart';
import 'package:howell_capstone/src/utilities/constants.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:howell_capstone/src/widgets/sign-up-form.dart';
import 'package:howell_capstone/theme/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';

  bool _rememberMe = false;

  Widget _buildForgotPasswordBtn() {
    //TODO:  figure out a way to implement this
    return Container(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: () {
            //print('forgot password pressed');
            //print('the email that the password reset is being sent to is ' + _email);
            //_passwordReset(_email); // pass the email to the password rest function, so firebase can send the password reset to the user

            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PasswordResetScreen(),
            ));
          },
          child: Text(
            'Forgot Password?',
            style: kLabelStyle,
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    //TODO:  figure out a way to implement this
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(
              unselectedWidgetColor:
                  Theme.of(context).colorScheme.primaryVariant,
            ),
            child: Checkbox(
              value: _rememberMe,

              /// the _rememberMe boolean
              checkColor: Theme.of(context).colorScheme.secondary,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (bool? value) {
                setState(() {
                  _rememberMe = !_rememberMe;
                  print("_rememberMe is " + _rememberMe.toString() + " now.");
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
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
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextField(
            obscureText: true,
            onChanged: (value) {
              setState(() {
                _password = value.trim(); // the password string
              });
            },
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
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
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              setState(() {
                _email = value.trim(); // the email string
              });
            },
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
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
              if (_rememberMe == true) {
                final SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                sharedPreferences.setString('email', _email);
              }

              _signin(_email,
                  _password); // pass email and password to _signin in function
            }));
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        print('the sign up gesture was pressed');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SignUpScreen()));
      },
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
              text: 'Sign Up',
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
//TODO: change size of logo and get rid of all the extra space around it using something like pixlr. implememt change notifier provider on reset password and sign up pages.

    return ChangeNotifierProvider(
        create: (_) => ThemeModel(),
        child: Consumer<ThemeModel>(
            builder: (context, ThemeModel themeNotifier, child) {
          return Scaffold(
            body: Padding(
              padding: kDefaultPadding,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 120),
                    Center(
                        child: Image(
                            image: themeNotifier.isDark
                                ? AssetImage('assets/SIMPL-dark.png')
                                : AssetImage(
                                    'assets/SIMPL-light.png'))), // based on whether theme is dark or light, we show the logo with appropriate coloring

                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 32,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          'New to this app?',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.7),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryVariant,
                                decoration: TextDecoration.underline,
                                decorationThickness: 1),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buildEmailTF(),
                    SizedBox(height: 10),
                    _buildPasswordTF(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildRememberMeCheckbox(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PasswordResetScreen()));
                          },
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryVariant,
                                decoration: TextDecoration.underline,
                                decorationThickness: 1),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    primaryButton(
                      context,
                      'Log In',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }

  _signin(String _email, String _password) async {
    try {
      var userCredentials = await auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      var userID = userCredentials.user!.uid;

      //Success
      //TODO: add an && here below to chek if emailVerified is already trure.   If so, immediately push to home screen. if emailVerified is not = to true, make it equal to true, then push to home page
      if (userCredentials.user!.emailVerified) {
        //!  we technically don't need this because we could just call .emailVerified to find out if the user is verified or not.
        //updates user verification field in firebase

        // print('we hit the updateUserVerification method.');
        //     await Database.updateUserVerification(
        //   userID: userID, emailVerified: true); //! sets to email verified to ture every time the user logs into the app, which is an uneccesary write to the db

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => StoreScreenCreatedBy()));
      }

      // ifuser hasn't verified email, we send them back to the email confirmation page
      else {
        userCredentials.user!.sendEmailVerification();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ConfirmEmailScreen()));
      }
    }

    //INFO: Fluttertoast will put pop up messages on the screen if auth encounters an error
    on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: 'No user exists with this email', gravity: ToastGravity.TOP);
      } else if (error.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: 'Incorrect Password', gravity: ToastGravity.TOP);
      } else if (error.code == 'invalid-email') {
        Fluttertoast.showToast(
            msg: 'Provided email address was not valid',
            gravity: ToastGravity.TOP);
      } else {
        Fluttertoast.showToast(msg: 'ERROR', gravity: ToastGravity.TOP);
      }
    }
  }

  Widget primaryButton(BuildContext context, buttonText) {
    return GestureDetector(
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.08,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.primary.withOpacity(.5)),
          child: Text(
            buttonText,
            style: textButton.copyWith(color: kWhiteColor),
          ),
        ),
        onTap: () async {
          //  shared pref allows user to remain logged in.  as long as this email is not null, the user will remain signed in
          if (_rememberMe == true) {
            final SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            sharedPreferences.setString('email', _email);
          }

          _signin(_email,
              _password); // pass email and password to _signin in function
        });
  }
}

//TODO: https://firebase.google.com/docs/reference/js/firebase.auth.Auth#signInWithEmailAndPassword   make switch statements with all of these Firebase Auth error messages

//TODO: https://github.com/MarcusNg/flutter_login_ui/blob/master/lib/screens/login_screen.dart   implement this formatting
