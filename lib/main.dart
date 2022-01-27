import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:howell_capstone/src/screens/home-screen.dart';
import 'package:howell_capstone/theme/custom-themes.dart';
import 'package:howell_capstone/theme/theme_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // app will not run with firebase unless it is initialized
//   await Firebase.initializeApp();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var email = prefs.getString('email');
//   print(
//       'Shared Preferences shows that the current email is ' + email.toString());
//   //runApp(App());
//   runApp(
//     MaterialApp(
//       title: 'SIM',
//       theme: CustomTheme.lightTheme,
//       darkTheme: CustomTheme.darkTheme,
//       home: email == null ? LoginScreen() : HomeScreen()));
// }

//main.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // app will not run with firebase unless it is initialized
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  print(
      'Shared Preferences shows that the current email is ' + email.toString());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
        return MaterialApp(
          title: 'SIM',
          // theme: themeNotifier.isDark ? CustomTheme.darkTheme : CustomTheme.lightTheme,
          theme: themeNotifier.isDark
              ? FlexThemeData.dark(scheme: FlexScheme.material)
              : FlexThemeData.light(
                  scheme: FlexScheme
                      .material), // this line changes the theme for the entire app
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        );
      }),
    );
  }
}
//Switching themes in the flutter apps - Flutterant

//TODO:  run "flutter format lib" in the terminal to autoformat all the code documents in lib folder. lib can be changed out for any directory.


///* SIMPL - Streamlined Inventory Management and Product Logistics  - i sent Dad the logo that I wnated to use in Messages. */