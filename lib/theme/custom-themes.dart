import 'package:flutter/material.dart';
import 'custom-colors.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    //1
    return ThemeData(
        //2
        appBarTheme: AppBarTheme(
            backgroundColor: CustomColors
                .red), // hot reload will not change it. only hot restart. also, this was a regression problem at flutter 2.5 using AppBarTheme is the workaround
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Montserrat', //3
        buttonTheme: ButtonThemeData(
          // 4
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: CustomColors.red,
        ));
  }

  static ThemeData get darkTheme {
    return ThemeData(
      //primaryColor: Colors.red,
      appBarTheme: AppBarTheme(backgroundColor: CustomColors.red),
      scaffoldBackgroundColor: Colors.black,
      fontFamily: 'Montserrat',
      textTheme: ThemeData.dark().textTheme,
      inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white))),
      buttonTheme: ButtonThemeData(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        buttonColor: CustomColors.red,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // onPrimary: Colors.yellow,  // this is the color of the text
          primary: CustomColors.red,
        ),
      ),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: CustomColors.red),
      hoverColor: CustomColors.gray,
    );
  }
}
