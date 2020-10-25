import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:real_estate/buyer_page/buyer_search_page.dart';
import 'package:real_estate/change_phone_no/change_no.dart';
import 'package:real_estate/registration/forgot_password.dart';
import 'package:real_estate/registration/signIn_page.dart';
import 'package:real_estate/registration/signUp_page.dart';
import 'package:real_estate/registration_forms/buyer_register.dart';
import 'package:real_estate/registration_forms/owner_register.dart';
import 'package:real_estate/registration_forms/realtor_register.dart';
import 'package:provider/provider.dart';
import 'buyer_page/search.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(RealEstateApp());
}

/// Light blue color #85e5ff
/// dark blue color #0084ca
/// header blue 47B3FE
/// text color black 000000

class RealEstateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChangeEmailAddress>(
      create: (context) => ChangeEmailAddress(),
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xFF47B3FE),
          accentColor: Color(0xFF47B3FE),
          focusColor: Color(0xFF0084CA),
        ),
        // initialRoute: LoginScreen.id,
        home: Search(),
        routes: {
          "LoginScreen": (context) => LoginScreen(),
          "SignUpScreen": (context) => SignUp(),
          "ForgotPassword": (context) => ForgotPassword(),
          "home": (context) => Home(),
          "OwnerReg": (context) => OwnerRegister(),
          "BuyerReg": (context) => BuyerRegister(),
          "RealtorReg": (context) => RealtorRegister(),
        },
      ),
    );
  }
}
