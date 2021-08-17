import 'package:flutter/material.dart';
import 'package:howell_capstone/services/auth.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final authService = Provider.of<AuthService>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // when the button is pressed, call the auth method and pass the text from email controller and password controller to email and password field respectively
                authService.signInWithEmailAndPassword(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Register'),
            )
          ],
        ));
  }
}
