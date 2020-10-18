import 'package:flutter/material.dart';
import 'package:real_estate/registration/signIn_page.dart';
import 'package:real_estate/registration/signUp_page.dart';
import 'package:real_estate/registration_forms/owner_register.dart';

import 'home_page.dart';

void main() {
  runApp(RealEstateApp());
}

/// Light blue color #85e5ff
/// dark blue color #0084ca
/// header blue 47B3FE
/// text color black 000000

class RealEstateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Color(0xFF47B3FE)),
      // initialRoute: LoginScreen.id,
      home: OwnerRegister(),
      routes: {
        "LoginScreen": (context) => LoginScreen(),
        "SignUpScreen": (context) => SignUp(),
        "home": (context) => Home(),
        "OwnerReg": (context) => OwnerRegister(),
      },
    );
  }
}
