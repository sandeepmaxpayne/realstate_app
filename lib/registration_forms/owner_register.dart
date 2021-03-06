import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/controller/owner_controller.dart';
import 'package:real_estate/modal/owner_modal.dart';
import 'package:real_estate/user_chat/change_email_address.dart';
import 'package:real_estate/values/snackbar_msg.dart';
import 'package:real_estate/values/styles.dart';

class OwnerRegister extends StatelessWidget {
  static const id = 'OwnerReg';

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Owner Registration',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
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

  int tag = 1;
  List<String> options = ['Plot', 'Apartment', 'Ind.house'];

  String fileType = '';
  String fileName = '';
  String optionalFileName = '';
  String operationText = '';
  File file;
  File optionalFile;

  bool isUploaded = true;
  TextEditingController ownerImageController = TextEditingController();
  TextEditingController ownerOptionController = TextEditingController();
  TextEditingController nameOwnerController = TextEditingController();
  TextEditingController phoneNoOwnerController = TextEditingController();
  TextEditingController emailOwnerController = TextEditingController();
  TextEditingController otherDocOwnerController = TextEditingController();
  TextEditingController locationOwnerController = TextEditingController();
  TextEditingController placeOwnerController = TextEditingController();
  TextEditingController areaOwnerController = TextEditingController();
  TextEditingController priceOwnerController = TextEditingController();
  TextEditingController amenityOwnerController = TextEditingController();

  Future filePicker(BuildContext context) async {
    try {
      if (fileType == 'others') {
        file = await FilePicker.getFile(
          type: FileType.any,
        );

        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print('file name: $fileName');
        //  _uploadFile(file, fileName);
      }
    } on PlatformException catch (e) {
      snackBarMessage('Unsupported Exception: $e', Colors.red);
    }
  }

  Future optionalFilePicker(BuildContext context) async {
    try {
      if (fileType == 'others') {
        optionalFile = await FilePicker.getFile(
          type: FileType.any,
        );

        optionalFileName = p.basename(file.path);
        setState(() {
          optionalFileName = p.basename(file.path);
        });
        print('file name: $optionalFileName');
      }
    } on PlatformException catch (e) {
      snackBarMessage('Unsupported Exception: $e', Colors.red);
    }
  }

  Future<void> _uploadFile(File file, String fileName) async {
    StorageReference storageReference;

    if (fileType == 'others') {
      storageReference =
          FirebaseStorage.instance.ref().child('owner/image/$fileName');
    }
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
    ownerImageController.text = url;
  }

  Future<void> _uploadOptionalDocument(
      File optionalFile, String optionalFileName) async {
    StorageReference storageReference;

    if (fileType == 'others') {
      storageReference = FirebaseStorage.instance.ref().child(
          'owner/${Provider.of<ChangeEmailAddress>(context, listen: false).emailAddress}/$optionalFileName');
    }
    final StorageUploadTask uploadTask = storageReference.putFile(optionalFile);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("Optional Url is $url");
    otherDocOwnerController.text = url;
  }

  @override
  Widget build(BuildContext context) {
    ownerOptionController.text = options[tag];
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
                //upload image
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: ListTile(
                          title: Text(
                            'Upload Image',
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: Icon(Icons.file_upload),
                          onTap: () {
                            setState(() {
                              fileType = 'others';
                            });
                            filePicker(context);
                          },
                        ),
                      ),
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: fileName,
                          ),
                          readOnly: true,
                          showCursor: false,
                          validator: (String value) {
                            value = fileName;
                            if (value.isEmpty) {
                              return "!Upload Image";
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nameOwnerController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Name must not be empty";
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
                    controller: phoneNoOwnerController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Contact Number must not be empty";
                      } else if (value.length != 10) {
                        return "Please enter 10 digit contact number";
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
                    controller: emailOwnerController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Email must not be empty";
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
                  child: Row(
                    children: [
                      Flexible(
                        child: ListTile(
                          title: Text(
                            'Upload Document (Optional)',
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: Icon(Icons.attach_file),
                          onTap: () {
                            setState(() {
                              fileType = 'others';
                            });
                            optionalFilePicker(context);
                          },
                        ),
                      ),
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: optionalFileName,
                          ),
                          readOnly: true,
                          showCursor: false,
                        ),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: locationOwnerController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "location must not be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'location',
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
                    controller: placeOwnerController,
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
                    value: tag,
                    onChanged: (val) => setState(() {
                      tag = val;
                      ownerOptionController.text = options[tag];
                      //print(options[tag]);
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
                    controller: areaOwnerController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Area must not be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Plot Area',
                        labelText: 'Plot Area',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: priceOwnerController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Price must not be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Price',
                        labelText: 'Price',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: amenityOwnerController,
                    maxLines: 3,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Amenities Field must not be empty";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Amenities',
                        labelText: 'Amenities',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                    keyboardType: TextInputType.multiline,
                  ),
                ),

                RaisedButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    if (widget._formKey.currentState.validate()) {
                      setState(() {
                        progress = true;
                      });
                      _uploadFile(file, fileName);
                      if (optionalFileName.isNotEmpty && optionalFile != null) {
                        _uploadOptionalDocument(optionalFile, optionalFileName);
                      }

                      if (ownerImageController.text.length > 5 &&
                          otherDocOwnerController.text.length > 5 &&
                          fileName.isNotEmpty &&
                          optionalFileName.isNotEmpty) {
                        OwnerModal ownerForm = OwnerModal(
                          ownerImageController.text,
                          nameOwnerController.text,
                          phoneNoOwnerController.text,
                          emailOwnerController.text.trim(),
                          otherDocOwnerController.text,
                          locationOwnerController.text,
                          placeOwnerController.text,
                          ownerOptionController.text,
                          areaOwnerController.text,
                          priceOwnerController.text,
                          amenityOwnerController.text,
                        );
                        OwnerController ownerController = OwnerController();

                        //store data to sheet
                        ownerController.submitForm(ownerForm,
                            (String response) {
                          print("response: $response");
                          if (response == OwnerController.STATUS_SUCCESS) {
                            //data saved successfully in google sheets
                            setState(() {
                              progress = false;
                            });
                            print(
                                "data recorded successfully ${ownerForm.toJson()}");
                            SnackBarMessage(
                                    message: "Data recorded successfully",
                                    color: Colors.green,
                                    loginScaffoldKey: _scaffoldKey)
                                .getMessage();
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
                      } else if (ownerImageController.text.length > 5 &&
                          fileName.isNotEmpty &&
                          optionalFileName.isNotEmpty) {
                        OwnerModal ownerForm = OwnerModal(
                          ownerImageController.text,
                          nameOwnerController.text,
                          phoneNoOwnerController.text,
                          emailOwnerController.text.trim(),
                          otherDocOwnerController.text,
                          locationOwnerController.text,
                          placeOwnerController.text,
                          ownerOptionController.text,
                          areaOwnerController.text,
                          priceOwnerController.text,
                          amenityOwnerController.text,
                        );
                        OwnerController ownerController = OwnerController();

                        //store data to sheet
                        ownerController.submitForm(ownerForm,
                            (String response) {
                          print("response: $response");
                          if (response == OwnerController.STATUS_SUCCESS) {
                            //data saved successfully in google sheets
                            setState(() {
                              progress = false;
                            });
                            print(
                                "data recorded successfully ${ownerForm.toJson()}");
                            SnackBarMessage(
                                    message: "Data recorded successfully",
                                    color: Colors.green,
                                    loginScaffoldKey: _scaffoldKey)
                                .getMessage();
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
                                message:
                                    "Please submit again! Error Saving Data",
                                color: Colors.red,
                                loginScaffoldKey: _scaffoldKey)
                            .getMessage();
                      }
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
