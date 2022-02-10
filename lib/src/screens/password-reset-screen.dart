import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:howell_capstone/src/screens/login-screen.dart';
import 'package:howell_capstone/src/utilities/constants.dart';
import 'package:howell_capstone/theme/theme_model.dart';
import 'package:provider/provider.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final auth = FirebaseAuth.instance;
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeModel(),
        child: Consumer<ThemeModel>(
            builder: (context, ThemeModel themeNotifier, child) {
          return Scaffold(
            body: Padding(
              padding: kDefaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 120),
                  Image(
                      image: themeNotifier.isDark
                          ? AssetImage('assets/SIMPL-dark.png')
                          : AssetImage(
                              'assets/SIMPL-light.png')), // based on whether theme is dark or light, we show the logo with appropriate coloring
                  SizedBox(height: 80),
                  Text(
                    'Reset Password',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Please enter your email address',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(.7),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  resetForm(),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                      },
                      child: primaryButton(context, 'Reset Password')),

                  SizedBox(
                    height: 20,
                  ),

                  Center(
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }

  Widget resetForm() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          setState(() {
            _email = value.trim(); // the email string
          });
        },
        decoration: InputDecoration(
            hintText: 'Email',
            hintStyle: TextStyle(color: kTextFieldColor),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor))),
      ),
    );
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
          try {
            print('the email is ' + _email);
            await auth.sendPasswordResetEmail(email: _email);
            Fluttertoast.showToast(
                msg: 'Reset Password email sent!',
                gravity: ToastGravity
                    .TOP); // shows a toast message confirming email sent
          } on FirebaseAuthException catch (error) {
            print(
                'an error was encountered with the forgot password function ');
            print("error code with reset password email is " + error.code);
            Fluttertoast.showToast(
                msg: 'ERROR: ' + '\n' + error.message.toString(),
                gravity: ToastGravity
                    .TOP); // shows a toast message confirming email sent
          }
        });
  }
}
