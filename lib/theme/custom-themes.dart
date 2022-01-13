import 'package:flutter/material.dart';
import 'custom-colors.dart';


class CustomTheme {
  static ThemeData get lightTheme { //1
    return ThemeData( //2
      appBarTheme: AppBarTheme(backgroundColor: CustomColors.cred), // hot reload will not change it. only hot restart. also, this was a regression problem at flutter 2.5 using AppBarTheme is the workaround
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Montserrat', //3
      buttonTheme: ButtonThemeData( // 4
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        buttonColor: CustomColors.cblue,
      )
    );
  }


  static ThemeData get darkTheme {
  return ThemeData(
    primaryColor: Colors.red,
    scaffoldBackgroundColor: Colors.black,
    fontFamily: 'Montserrat',
    textTheme: ThemeData.dark().textTheme,
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      buttonColor: CustomColors.cyellow,
    )
  );
}
}