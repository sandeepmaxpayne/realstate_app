import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/clipper/shape_clipper.dart';
import 'package:real_estate/registration/forgot_password.dart';
import 'package:real_estate/registration/signUp_page.dart';
import 'package:real_estate/user_chat/change_email_address.dart';
import 'package:real_estate/values/borders.dart';
import 'package:real_estate/values/custom_button.dart';
import 'package:real_estate/values/cutom_field.dart';
import 'package:real_estate/values/gradients.dart';
import 'package:real_estate/values/snackbar_msg.dart';
import 'package:real_estate/values/styles.dart';

import '../home_page.dart';

class LoginScreen extends StatefulWidget {
  static const id = "LoginScreen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

//TODO Fetch the phone No and set it to the Provider ChangePhoneNo
class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;
  String loginEmail;
  String loginPassword;
  final _loginScaffoldKey = GlobalKey<ScaffoldState>();
  bool progress = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var heightOfScreen = MediaQuery.of(context).size.height;
    var widthOfScreen = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);

    return Scaffold(
      key: _loginScaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: progress,
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: ClipPath(
                    clipper: ReverseWaveShapeClipper(),
                    child: Container(
                      height: heightOfScreen * 0.5,
                      width: widthOfScreen,
                      decoration: BoxDecoration(
                        gradient: Gradients.curvesGradient3,
                      ),
                    ),
                  ),
                ),
                ListView(
                  padding: EdgeInsets.all(0.0),
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(
                      height: heightOfScreen * 0.5 * 0.90,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: widthOfScreen * 0.15),
                      child: Text(
                        "Log in",
                        style: theme.textTheme.headline3.copyWith(
                          color: Color(0xFF666D73),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: heightOfScreen * 0.05,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: _buildForm(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    ThemeData theme = Theme.of(context);
    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          CustomTextFormField(
            hasTitle: true,
            title: 'Email',
            validator: (value) {
              if (value.isEmpty) {
                return 'Email cannot be empty !';
              }
              return null;
            },
            onChanged: (value) {
              loginEmail = value;
            },
            titleStyle: theme.textTheme.subtitle1.copyWith(
              color: Color(0xFF247EAA),
              fontSize: 14.0,
            ),
            textInputType: TextInputType.text,
            hintTextStyle: Styles.customTextStyle(
              color: Color(0xFFB2B2B2),
            ),
            enabledBorder: Borders.customUnderlineInputBorder(
              color: Color(0xFFD0EBF7),
            ),
            focusedBorder: Borders.customUnderlineInputBorder(
              color: Color(0xFF69C7C6),
            ),
            textStyle: Styles.customTextStyle(
              color: Color(0xFF606060),
            ),
            hintText: "enter email",
          ),
          SizedBox(
            height: 20.0,
          ),
          CustomTextFormField(
            hasTitle: true,
            title: 'Password',
            validator: (value) {
              if (value.isEmpty) {
                return "Password cannot be empty";
              }
              return null;
            },
            onChanged: (value) {
              loginPassword = value;
            },
            titleStyle: theme.textTheme.subtitle1.copyWith(
              color: Color(0xFF247EAA),
              fontSize: 14.0,
            ),
            textInputType: TextInputType.text,
            hintTextStyle: Styles.customTextStyle(
              color: Color(0xFFB2B2B2),
            ),
            enabledBorder: Borders.customUnderlineInputBorder(
              color: Color(0xFFD0EBF7),
            ),
            focusedBorder: Borders.customUnderlineInputBorder(
              color: Color(0xFF69C7C6),
            ),
            textStyle: Styles.customTextStyle(
              color: Color(0xFF606060),
            ),
            hintText: "Enter Password",
            obscured: true,
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: widthOfScreen * 0.6,
            child: CustomButton(
              title: 'Log IN',
              color: Color(0xFF2DA6AB),
              textStyle: theme.textTheme.button.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16.0,
              ),
              onPressed: () async {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                if (_formKey.currentState.validate()) {
                  setState(() {
                    progress = true;
                  });

                  try {
                    final logUser = await auth.signInWithEmailAndPassword(
                        email: loginEmail, password: loginPassword);
                    if (logUser != null) {
                      setState(() {
                        progress = false;
                      });
                      Provider.of<ChangeEmailAddress>(context, listen: false)
                          .changeData(loginEmail);
                      Navigator.pushNamed(context, Home.id);
                    }
                  } catch (e) {
                    setState(() {
                      progress = false;
                    });
                    SnackBarMessage(
                            color: Colors.red,
                            message: e.message,
                            loginScaffoldKey: _loginScaffoldKey)
                        .getMessage();
                  }
                }
              },
            ),
          ),
          SizedBox(
            height: heightOfScreen * 0.04,
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, SignUp.id),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Don\'t have an account',
                    style: theme.textTheme.bodyText1.copyWith(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  TextSpan(
                    text: 'Sign Up',
                    style: theme.textTheme.subtitle2.copyWith(
                      color: Color(0xFF247EAA),
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: heightOfScreen * 0.04,
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, ForgotPassword.id),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Forgot Password ?',
                    style: theme.textTheme.bodyText1.copyWith(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
        ],
      ),
    );
  }
}
