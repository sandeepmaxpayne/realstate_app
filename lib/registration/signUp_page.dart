import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/clipper/shape_clipper.dart';
import 'package:real_estate/controller/user_controller.dart';
import 'package:real_estate/modal/user_modal.dart';
import 'package:real_estate/user_chat/change_email_address.dart';
import 'package:real_estate/values/borders.dart';
import 'package:real_estate/values/custom_button.dart';
import 'package:real_estate/values/cutom_field.dart';
import 'package:real_estate/values/gradients.dart';
import 'package:real_estate/values/snackbar_msg.dart';
import 'package:real_estate/values/styles.dart';

import '../home_page.dart';

class SignUp extends StatefulWidget {
  static const id = "SignUpScreen";
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String registerEmail;
  String registerPassword;
  final _auth = FirebaseAuth.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showSpinner = false;
  bool onCheck = false;
  String name;
  String phoneNo;
  String address;
  _verify() {
    return _formKey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    var heightOfScreen = MediaQuery.of(context).size.height;
    var widthOfScreen = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
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
                    clipper: WaveShapeClipper(),
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
                      height: heightOfScreen * 0.5 * 0.6,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: widthOfScreen * 0.15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Sign',
                            style: theme.textTheme.headline3.copyWith(
                              color: Color(0xFF666D73),
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Sig',
                                  style: theme.textTheme.headline3.copyWith(
                                    color: Colors.transparent,
                                    height: 0.7,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Up',
                                  style: theme.textTheme.headline3.copyWith(
                                    color: Color(0xFF666D73),
                                    height: 0.7,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          CustomTextFormField(
            hasTitle: true,
            title: 'Name',
            validator: (value) {
              if (value.isEmpty) {
                return 'Name cannot be empty !';
              }
              return null;
            },
            onChanged: (value) {
              name = value;
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
            hintText: 'enter full name',
          ),
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
              registerEmail = value;
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
            hintText: 'enter email',
          ),
          SizedBox(
            height: 16.0,
          ),
          CustomTextFormField(
            hasTitle: true,
            title: 'Password',
            validator: (value) {
              if (value.isEmpty) {
                return 'Password cannot be empty !';
              }
              return null;
            },
            onChanged: (value) {
              registerPassword = value;
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
            hintText: 'Set Password',
            obscured: true,
          ),
          SizedBox(
            height: 16.0,
          ),
          CustomTextFormField(
            hasTitle: true,
            title: 'Phone Number',
            validator: (value) {
              if (value.isEmpty) {
                return 'Phone number cannot be empty !';
              } else if (value.length != 10) {
                return 'Please enter 10 digit phone number';
              }
              return null;
            },
            onChanged: (value) {
              phoneNo = value;
            },
            titleStyle: theme.textTheme.subtitle1.copyWith(
              color: Color(0xFF247EAA),
              fontSize: 14.0,
            ),
            textInputType: TextInputType.number,
            hintTextStyle: Styles.customTextStyle(color: Color(0xFFB2B2B2)),
            enabledBorder: Borders.customUnderlineInputBorder(
              color: Color(0xFFD0EBF7),
            ),
            focusedBorder: Borders.customUnderlineInputBorder(
              color: Color(0xFF69C7C6),
            ),
            textStyle: Styles.customTextStyle(color: Color(0xFF606060)),
            hintText: 'Enter Phone Number',
          ),
          TextFormField(
            maxLines: 3,
            maxLength: 100,
            style: Styles.customTextStyle(color: Color(0xFF606060)),
            validator: (add) {
              if (add.isEmpty) {
                return 'Address cannot be empty';
              }
              return null;
            },
            onChanged: (value) {
              address = value;
            },
            decoration: InputDecoration(
              hintText: "Enter Address",
              labelText: "Address",
              hintStyle: Styles.customTextStyle(color: Color(0xFFB2B2B2)),
              labelStyle: theme.textTheme.subtitle1.copyWith(
                color: Color(0xFF247EAA),
                fontSize: 14.0,
              ),
            ),
            keyboardType: TextInputType.text,
          ),
          Row(
            children: <Widget>[
              Checkbox(
                value: onCheck,
                activeColor: Color(0xFF2DA6AB),
                onChanged: (value) {
                  setState(() {
                    onCheck = !onCheck;
                  });
                },
              ),
              Text('I agree with the Terms and Conditions')
            ],
          ),
          Container(
            width: widthOfScreen * 0.6,
            child: CustomButton(
              title: 'Sign Up',
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
                if (_verify() && onCheck == true) {
                  UserModal feedForm =
                      UserModal(name, registerEmail, phoneNo, address);

                  UserController formController = UserController();

                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final user = await _auth.createUserWithEmailAndPassword(
                        email: registerEmail, password: registerPassword);
                    //store data to sheet
                    formController.submitForm(feedForm, (String response) {
                      print("response: $response");
                      if (response == UserController.STATUS_SUCCESS) {
                        //data saved successfully in google sheets
                        print(
                            "data recorded successfully ${feedForm.toJson()}");
                        SnackBarMessage(
                                message: "Data recorded successfully",
                                color: Colors.green,
                                loginScaffoldKey: _scaffoldKey)
                            .getMessage();
                      } else {
                        print("error saving data");
                        SnackBarMessage(
                                message: "Error Saving Data!",
                                color: Colors.red,
                                loginScaffoldKey: _scaffoldKey)
                            .getMessage();
                      }
                    });

                    if (user != null) {
                      setState(() {
                        showSpinner = false;
                      });
                      Provider.of<ChangeEmailAddress>(context, listen: false)
                          .changeData(registerEmail);
                      Navigator.pushNamed(context, Home.id);
                    }
                  } catch (e) {
                    setState(() {
                      showSpinner = false;
                    });
                    SnackBarMessage(
                            message: e.message,
                            color: Colors.red,
                            loginScaffoldKey: _scaffoldKey)
                        .getMessage();
                  }
                }
              },
              elevation: 6.0,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
        ],
      ),
    );
  }
}
