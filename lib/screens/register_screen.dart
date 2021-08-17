import 'package:flutter/material.dart';
import 'package:howell_capstone/services/auth.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final authService = Provider.of<AuthService>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
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
              //  when the button is pressed, call the auth create method and pass the text from emailcontroller and password controller respectively
              onPressed: () async {
                await authService.createUserWithEmailAndPassword(
                    emailController.text.trim(),
                    passwordController.text.trim());
                Navigator.pop(context);
              },
              child: Text('Register'),
            )
          ],
        ));
  }
}
