import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:real_estate/buyer_page/search.dart';
import 'package:real_estate/controller/buyer_controller.dart';
import 'package:real_estate/modal/buyer_modal.dart';
import 'package:real_estate/values/snackbar_msg.dart';
import 'package:real_estate/values/styles.dart';

class BuyerRegister extends StatelessWidget {
  static const id = 'BuyerReg';

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Buyer Registration',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
                semanticLabel: 'Search Property',
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
          children: [
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
              title: Text('See Real Estate'),
              leading: Icon(
                Icons.domain,
              ),
              onTap: () {
                Navigator.pushNamed(context, Search.id);
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: BuildForm(formKey: formKey),
      ),
    );
  }
}

class BuildForm extends StatefulWidget {
  const BuildForm({
    Key key,
    @required GlobalKey<FormState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;

  @override
  _BuildFormState createState() => _BuildFormState();
}

class _BuildFormState extends State<BuildForm> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  snackBarMessage(String message, Color color) {
    return _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      backgroundColor: color,
      behavior: SnackBarBehavior.fixed,
    ));
  }

  bool progress = false;

  int optionTag = 1;
  int buyerTag = 0;
  List<String> options = ['Plot', 'Apartment', 'Ind.house'];
  List<String> buyerType = ['Individual Buying', 'Group Buying'];

  String fileType = '';
  String fileName = '';
  String operationText = '';
  File file;
  bool isUploaded = true;
  var selectedRange = RangeValues(500000, 2000000);
  TextEditingController startBudgetController = TextEditingController();
  TextEditingController endBudgetController = TextEditingController();
  TextEditingController buyerOptionController = TextEditingController();
  TextEditingController buyerTypeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController plotSizeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    buyerOptionController.text = options[optionTag];
    buyerTypeController.text = buyerType[buyerTag];

    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: progress,
        child: Form(
          key: widget._formKey,
          child: SingleChildScrollView(
            physics: ScrollPhysics(parent: BouncingScrollPhysics()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nameController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Error must not be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Name',
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        )),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: phoneNoController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Contact Number must not be empty";
                      } else if (value.length != 10) {
                        return "Should be 10 digit contact number";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Contact Number',
                        labelText: 'Contact Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        )),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Mail ID must not be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Mail ID',
                        labelText: 'Mail ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        )),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: locationController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Location must not be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Location',
                        labelText: 'Location',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        )),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: placeController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Place must not be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Place',
                        labelText: 'Place',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChipsChoice<int>.single(
                    value: optionTag,
                    onChanged: (val) => setState(() {
                      optionTag = val;
                      buyerOptionController.text = options[optionTag];
                      //  print(options[optionTag]);
                    }),
                    choiceItems: C2Choice.listFrom<int, String>(
                      source: options,
                      value: (i, v) => i,
                      label: (i, v) => v,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: plotSizeController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Plot size must not be empty";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Plot Size',
                        labelText: 'Plot Size',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChipsChoice<int>.single(
                    value: buyerTag,
                    onChanged: (val) => setState(() {
                      buyerTag = val;
                      buyerTypeController.text = buyerType[buyerTag];
                      // print(buyerType[buyerTag]);
                    }),
                    choiceItems: C2Choice.listFrom<int, String>(
                      source: buyerType,
                      value: (i, v) => i,
                      label: (i, v) => v,
                    ),
                  ),
                ),
                RangeSlider(
                  onChanged: (RangeValues newRange) {
                    setState(() {
                      selectedRange = newRange;
                      startBudgetController.text =
                          selectedRange.start.toStringAsFixed(2);
                      endBudgetController.text =
                          selectedRange.end.toStringAsFixed(2);
                      print('selected range: $selectedRange');
                    });
                  },
                  min: 100000.0,
                  max: 10000000.0,
                  divisions: 100,
                  values: selectedRange,
                  activeColor: Theme.of(context).primaryColor,
                  labels: RangeLabels(
                      '\u20B9${selectedRange.start.toStringAsFixed(2)}',
                      '\u20B9${selectedRange.end.toStringAsFixed(2)}'),
                ),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    print("option: ${buyerOptionController.text}");
                    print("buyerType: ${buyerTypeController.text}");
                    print(
                        "start Budget: ${startBudgetController.text} end Budget :${endBudgetController.text}");
                    if (widget._formKey.currentState.validate()) {
                      setState(() {
                        progress = true;
                      });

                      BuyerModal buyerForm = BuyerModal(
                          nameController.text,
                          phoneNoController.text,
                          emailController.text.trim(),
                          locationController.text,
                          placeController.text,
                          buyerOptionController.text,
                          plotSizeController.text,
                          buyerOptionController.text,
                          startBudgetController.text,
                          endBudgetController.text);
                      BuyerController buyerController = BuyerController();

                      //store data to sheet
                      buyerController.submitForm(buyerForm, (String response) {
                        print("response: $response");
                        if (response == BuyerController.STATUS_SUCCESS) {
                          //data saved successfully in google sheets
                          setState(() {
                            progress = false;
                          });
                          print(
                              "data recorded successfully ${buyerForm.toJson()}");
                          SnackBarMessage(
                                  message: "Data recorded successfully",
                                  color: Colors.green,
                                  loginScaffoldKey: _scaffoldKey)
                              .getMessage();
                          Navigator.pushNamed(context, Search.id);
                        } else {
                          setState(() {
                            progress = false;
                          });
                          print("error saving data");
                          SnackBarMessage(
                                  message: "Error Saving Data!",
                                  color: Colors.red,
                                  loginScaffoldKey: _scaffoldKey)
                              .getMessage();
                        }
                      });
                    } else {
                      setState(() {
                        progress = false;
                      });
                      SnackBarMessage(
                          message: "Please submit again! Error Saving Data",
                          color: Colors.red,
                          loginScaffoldKey: _scaffoldKey);
                    }
                  },
                  child: Text(
                    'Submit',
                    style: Styles.customTextStyle2(
                        color: Colors.black87, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
