import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_estate/card_view.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  static final id = "home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //final _auth = FirebaseAuth.instance;
  final TextEditingController userMobNo = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
    getCurrentUser();
  }

  void getCurrentUser() {
    /**   try {
      final user = _auth.currentUser;
      if (user != null) {
        var loggedInUser = user;
        print('user email" ${loggedInUser.email}');
      }
    } catch (e) {
      print(e);
    } **/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
//                image: DecorationImage(
//                    image: AssetImage("image/logo.png"), fit: BoxFit.fill),
              ),
            ),
            ListTile(
              title: Text('Notification'),
              leading: Icon(
                Icons.notifications,
              ),
              onTap: () {
                //TODO message
              },
            ),
            ListTile(
              title: Text('share'),
              leading: Icon(Icons.share),
              onTap: () {
                Share.share('new app link');
              },
            ),
            ListTile(
              title: Text('contact'),
              leading: Icon(Icons.contact_mail),
              onTap: () {
                final Uri _emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'admin@globaladmitcare.xyz',
                    queryParameters: {'subject': 'Regarding Admit Hospital'});
                launch(_emailLaunchUri.toString());
              },
            ),
            ListTile(
              title: Text('Privacy Policy'),
              leading: Icon(Icons.security),
              onTap: () async {
                const _privacyPolicuUrl =
                    "https://docs.google.com/document/d/1WNnhbG_E5wyE3pTPOMxJxtjev1opbbhDWVQR0ijm-7o/edit?usp=sharing";
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
                  //_auth.signOut();
                  //     Navigator.pushReplacementNamed(context, LoginScreen.id);
                })
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
            onPress: () {},
            title1: 'Owner',
            title2: 'Owner of the products',
            desc: 'short descp',
          ),
          ChatCard(
            onPress: () {},
            title1: 'Realtor',
            title2: 'short title',
            desc: 'short descp',
          ),
          ChatCard(
            onPress: () {},
            title1: 'Admin Employee',
            title2: 'Admin Employee Registration',
            desc: 'none',
          ),
          ChatCard(
            onPress: () {},
            title1: 'Buyer',
            title2: 'buyer',
            desc: 'none',
          )

          /**  RaisedButton(
                  onPressed: () async {
                  GroupChatController().getFeedList().then((groupChatLink) {
                  setState(() {
                  this.groupChatLink = groupChatLink;
                  print("grouplink:${groupChatLink[0].whatsAppLink}");
                  });
                  });
                  if (groupChatLink.isNotEmpty) {
                  String chatLink = groupChatLink[0].whatsAppLink;
                  if (await canLaunch(chatLink)) {
                  await launch(chatLink);
                  } else {
                  throw snackBarMessage("No group chat scheduled by doctor !",
                  Colors.yellow.shade300);
                  }
                  } else {
                  snackBarMessage(
                  "No group chat scheduled !", Colors.yellow.shade300);
                  }
                  },
                  color: Color(0xFFFFE97D),
                  child: Text("Start Group Chat"),
                  ), **/
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
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "This cannot be empty !";
                      } else if (value.length != 10) {
                        return "Enter your 10 digit mobile No to Chat";
                      }
                      return null;
                    },
                    controller: userMobNo,
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: 'Mobile No',
                        hintText: 'Enter your Registered Mobile No',
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
                //TODO
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
