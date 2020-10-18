import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
  File _imageFile;

  List<String> options = ['Plot', 'Apartment', 'Ind.house'];

  String fileType = '';
  String fileName = '';
  String operationText = '';
  File file;
  bool isUploaded = true;
  TextEditingController ownerImageController = TextEditingController();

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

  Future<void> _uploadFile(File file, String fileName) async {
    StorageReference storageReference;

    if (fileType == 'others') {
      storageReference =
          FirebaseStorage.instance.ref().child('owner/id/$fileName');
    }
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
    ownerImageController.text = url;
  }

  @override
  Widget build(BuildContext context) {
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
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Error must not be empty";
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
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Error must not be empty";
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
                      print(options[tag]);
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
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Error must not be empty";
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
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Error must not be empty";
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
                    maxLines: 3,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Error must not be empty";
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
                  color: Color(0xFFFFE97D),
                  onPressed: () {
                    if (widget._formKey.currentState.validate()) {
                      setState(() {
                        progress = true;
                      });
                      _uploadFile(file, fileName);
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
