import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:howell_capstone/src/screens/confirm-email-screen.dart';
import 'package:howell_capstone/src/screens/home-screen.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:howell_capstone/theme/custom-colors.dart';
import 'package:intl/intl.dart';

// Define a custom Form widget.
class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  SignUpFormState createState() {
    return SignUpFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class SignUpFormState extends State<SignUpForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  bool _isProcessing = false;
  bool _isObscure = true; // for obscuring text in the password creation field

  //  these controllers will store the data inputed by the user.
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  //quick calculation of the current date for mostRecentScanIn section in the Firestore DB using the intl package for date formatting
  String _currentDateTime = DateFormat.yMEd().add_jms().format(DateTime.now());

  // this regex pattern will only accept numbers
  RegExp numbersOnlyRegex = RegExp(r'[0-9]');
  RegExp numbersTextHyphenRegex = RegExp(r'[a-zA-Z0-9 -]');

  final auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';

  //*really good article on validation - https://michaeladesola1410.medium.com/input-validation-flutter-dfe433caec5c

  @override
  Widget build(BuildContext context) {
    //TODO:  Bottom OverflOwed by 45 Pixels on Samsung s20FE. fix it.

    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.

          //text field for first name
          TextFormField(
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'First name',
            ),
            controller: _firstNameController,
            keyboardType: TextInputType.text,
            validator: (value) {
              // The validator receives the text that the user has entered.
              if (value == null || value.isEmpty) {
                //TODO: put a regex here that can accept str like "Samuel", but not sql injection type of stuff.  apply same regex at all similar fields.
                return 'Please enter some text';
              }
              return null;
            },
          ),

          //  text field for last name
          TextFormField(
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Last name',
            ),
            controller: _lastNameController,
            keyboardType: TextInputType.text,
            validator: (value) {
              // The validator receives the text that the user has entered.
              if (value == null || value.isEmpty) {
                //TODO: put a regex here that can accept str like "Samuel", but not sql injection type of stuff.  apply same regex at all similar fields.
                return 'Please enter some text';
              }
              return null;
            },
          ),

          // text field for email
          TextFormField(
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Email',
            ),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              // The validator receives the text that the user has entered.
              if (value == null || value.isEmpty) {
                //TODO: put a regex here that can accept str like "Samuel", but not sql injection type of stuff.  apply same regex at all similar fields.
                return 'Please enter some text';
              }
              _email = _emailController.text;
              return null;
            },
          ),

          // text field for password
          TextFormField(
            obscureText: _isObscure,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Password',
              suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  }),
            ),
            controller: _passwordController,
            keyboardType: TextInputType.text,
            validator: (value) {
              // The validator receives the text that the user has entered.
              if (value == null || value.isEmpty) {
                //TODO: put a regex here that can accept str like "Samuel", but not sql injection type of stuff.  apply same regex at all similar fields.
                return 'Please enter some text';
              }
              _password = _passwordController.text;
              return null;
            },
          ),

          _isProcessing
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      CustomColors.red,
                    ),
                  ),
                )
              : Container(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        CustomColors.red,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isProcessing = true;
                        });

                        _signup(_email,
                            _password); // try to add the user via authentication.  if it works, then add a user profile in the database

                        setState(() {
                          _isProcessing = false;
                        });
                      }
                    },
                    child: const Text('Submit'),
                  ),
                )
        ],
      ),
    );
  }

  _signup(String _email, String _password) async {
    try {
      var userCredentials = await auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      var userID = userCredentials.user!.uid;

      /// this is the user id that we pass to the add user database method so that it creates an entry
      await Database.addUser(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        dateAccountCreated: _currentDateTime.toString(),
        userID: userID,
        emailVerified: false,
      );

      //Success
      userCredentials.user!.sendEmailVerification();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ConfirmEmailScreen()));
      return true;
    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        Fluttertoast.showToast(
            msg: 'Password needs to be at least 8 characters',
            gravity: ToastGravity.TOP);
        return false;
      } else if (error.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: 'This email is already associated with an account',
            gravity: ToastGravity.TOP);
        return false;
      } else if (error.code == 'invalid-email') {
        Fluttertoast.showToast(
            msg: 'Provided email address was not valid',
            gravity: ToastGravity.TOP);
        return false;
      } else {
        Fluttertoast.showToast(msg: 'ERROR', gravity: ToastGravity.TOP);
        return false;
      }
    }
  }
}
