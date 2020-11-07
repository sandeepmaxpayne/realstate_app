import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/card_view.dart';
import 'package:real_estate/registration/signIn_page.dart';
import 'package:real_estate/registration_forms/buyer_register.dart';
import 'package:real_estate/registration_forms/owner_register.dart';
import 'package:real_estate/registration_forms/realtor_register.dart';
import 'package:real_estate/user_chat/change_email_address.dart';
import 'package:real_estate/user_chat/chat.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'controller/buyer_controller.dart';
import 'controller/owner_controller.dart';
import 'controller/realtor_controller.dart';
import 'controller/user_controller.dart';
import 'modal/buyer_modal.dart';
import 'modal/owner_modal.dart';
import 'modal/realtor_modal.dart';
import 'modal/user_modal.dart';

class Home extends StatefulWidget {
  static final id = "home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController userEmailAddress = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<OwnerModal> ownerData = List<OwnerModal>();
  List<RealtorModal> realtorData = List<RealtorModal>();
  List<BuyerModal> buyerData = List<BuyerModal>();
  List<String> allUsersEmails = [];
  List<UserModal> usersData = List<UserModal>();
  List<String> loggedInUsersEmail = [];

  snackBarMessage(String message, Color color) {
    return _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.black),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      backgroundColor: color,
      behavior: SnackBarBehavior.fixed,
    ));
  }

  @override
  void initState() {
    super.initState();
    OwnerController().getFeedList().then((ownerData) {
      setState(() {
        this.ownerData = ownerData;
      });
    });
    RealtorController().getFeedList().then((realtorData) {
      setState(() {
        this.realtorData = realtorData;
      });
    });
    BuyerController().getFeedList().then((buyerData) {
      setState(() {
        this.buyerData = buyerData;
      });
    });
    UserController().getFeedList().then((usersData) {
      setState(() {
        this.usersData = usersData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Home',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          )
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(''),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                image: DecorationImage(
                    image: AssetImage("assets/icons/playstore.png"),
                    fit: BoxFit.fill),
              ),
            ),
            ListTile(
              title: Text('share'),
              leading: Icon(Icons.share),
              onTap: () {
                Share.share(
                    'Join GroupEstate group: https://play.google.com/store/apps/details?id=com.appruloft.real_estate');
              },
            ),
            ListTile(
              title: Text('contact'),
              leading: Icon(Icons.contact_mail),
              onTap: () {
                final Uri _emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'admin@globaladmitcare.xyz',
                    queryParameters: {
                      'subject': 'Regarding RealEstate, Apartment'
                    });
                launch(_emailLaunchUri.toString());
              },
            ),
            ListTile(
              title: Text('Privacy Policy'),
              leading: Icon(Icons.security),
              onTap: () async {
                const _privacyPolicuUrl =
                    "https://docs.google.com/document/d/1dTqU9kGESAcpbe0JcD76oGRo9QfvQ-q6_9O66AT56kk/edit?usp=sharing";
                if (await canLaunch(_privacyPolicuUrl)) {
                  await launch(_privacyPolicuUrl);
                } else {
                  throw snackBarMessage("No group chat scheduled by doctor !",
                      Colors.orange.shade500);
                }
              },
            ),
            ListTile(
              title: Text('Chat with Admin'),
              leading: Icon(Icons.chat),
              onTap: () async {
                _showDialog();
              },
            ),
            ListTile(
                title: Text('Sign Out'),
                leading: Icon(Icons.exit_to_app),
                onTap: () {
                  _auth.signOut();
                  Navigator.pushReplacementNamed(context, LoginScreen.id);
                }),
          ],
        ),
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Text("Register",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w600)),
          ),
          ChatCard(
            onPress: () {
              Navigator.pushNamed(context, OwnerRegister.id);
            },
            title1: 'Owner',
            title2: 'Owner of the property',
            desc: '',
          ),
          ChatCard(
            onPress: () {
              Navigator.pushNamed(context, RealtorRegister.id);
            },
            title1: 'Realtor',
            title2: 'real estate agent',
            desc: '',
          ),
          ChatCard(
            onPress: () {
              Navigator.pushNamed(context, BuyerRegister.id);
            },
            title1: 'Buyer',
            title2: 'buyer',
            desc: '',
          ),
          ChatCard(
            onPress: () {
              /// Check if Logged In users is not related to owner, realtor or buyer
              for (int i = 0; i < ownerData.length - 1; i++) {
                allUsersEmails.add(ownerData[i].email.trim());
              }
              for (int i = 0; i < realtorData.length - 1; i++) {
                allUsersEmails.add(realtorData[i].email.trim());
              }
              for (int i = 0; i < buyerData.length - 1; i++) {
                allUsersEmails.add(buyerData[i].email.trim());
              }
              for (int i = 0; i < usersData.length - 1; i++) {
                loggedInUsersEmail.add(usersData[i].email.trim());
              }
              print("allusers: ${allUsersEmails.toSet().toList()}");
              print("LoggedInUsers: ${loggedInUsersEmail.toSet().toList()}");

              if (loggedInUsersEmail.contains(
                      Provider.of<ChangeEmailAddress>(context, listen: false)
                          .emailAddress) &&
                  !allUsersEmails.toSet().toList().contains(
                      Provider.of<ChangeEmailAddress>(context, listen: false)
                          .emailAddress)) {
                Navigator.pushNamed(context, ChatScreen.id);
              } else {
                return snackBarMessage(
                    "Please open settings to chat with admin !",
                    Colors.orangeAccent);
              }
            },
            title1: 'Chat with Admin',
            title2: 'Logged In Users Chat only (Not realtor/owner/buyer)',
            desc: '',
          ),
        ],
      )),
    );
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: _SystemPadding(
        child: AlertDialog(
          elevation: 5.0,
          contentPadding: EdgeInsets.all(16.0),
          content: Row(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Owner/Realtor/Buyer email !";
                      }
                      return null;
                    },
                    controller: userEmailAddress,
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: 'email address',
                        hintText: 'Enter realtor/owner/buyer email',
                        hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.black45)),
                  ),
                ),
              )
            ],
          ),
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('OPEN'),
              onPressed: () {
                for (int i = 0; i < ownerData.length - 1; i++) {
                  allUsersEmails.add(ownerData[i].email.trim());
                }
                for (int i = 0; i < realtorData.length - 1; i++) {
                  allUsersEmails.add(realtorData[i].email.trim());
                }
                for (var i = 0; i < buyerData.length - 1; i++) {
                  allUsersEmails.add(buyerData[i].email.trim());
                }

                print("AllUsersEmail: ${allUsersEmails.toSet().toList()}");
                print("user email: ${userEmailAddress.text.trim()}");
                if (_formKey.currentState.validate()) {
                  if (allUsersEmails
                      .toSet()
                      .toList()
                      .contains(userEmailAddress.text.trim())) {
                    Provider.of<ChangeEmailAddress>(context, listen: false)
                        .changeData(userEmailAddress.text.trim());
                    Navigator.pushNamed(context, ChatScreen.id);
                  } else {
                    Navigator.pop(context);
                  }
                  // Navigator.pop(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;
  _SystemPadding({this.child});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return AnimatedContainer(
      padding: mediaQuery.viewInsets,
      duration: Duration(milliseconds: 300),
      child: child,
    );
  }
}
