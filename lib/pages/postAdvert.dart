import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:retry/retry.dart';
import 'package:dio/dio.dart';
import '../utilities/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';


class PostAdvertPage extends StatefulWidget {
  @override
  _PostAdvertPageState createState() => _PostAdvertPageState();
}

class _PostAdvertPageState extends State<PostAdvertPage> {
  var descriptionController = TextEditingController();
  var locationController = TextEditingController();
  var ownerController = TextEditingController();
  var titleController = TextEditingController();
  var phoneController = TextEditingController();
  var categoryController = TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  DateTime date;
  File imageFile;
  bool _autoValidate = false;
  bool createProgress = false;
  bool imageEmpty = false;
  @override
  Widget build(BuildContext context) {
    var sizeW = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Create Advert"),
              centerTitle: true,
              backgroundColor: Colors.blueGrey[800],
            ),
            body: Container(
                padding: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blueGrey[800], Colors.blueGrey[100]],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
                child: Form(
                    key: _key,
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      children: <Widget>[
                        Column(crossAxisAlignment: CrossAxisAlignment.center,
                            // List slides
                            children: <Widget>[
                              SizedBox(height: 10),
                              profileImageUploader(context),
                              //Bio
                              SizedBox(height: 10),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: TextFormField(
                                    controller: titleController,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    obscureText: false,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      labelText: 'Title',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                      ),
                                    ),
                                    cursorColor: Colors.white,
                                    autovalidate: _autoValidate,
                                    validator: (String value) {
                                      return validateInput(value);
                                    },
                                  )),
                              SizedBox(height: 10),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: TextFormField(
                                    controller: descriptionController,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    obscureText: false,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      labelText: 'Description',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                      ),
                                    ),
                                    cursorColor: Colors.white,
                                    autovalidate: _autoValidate,
                                    validator: (String value) {
                                      return validateInput(value);
                                    },
                                  )),
                              SizedBox(height: 10),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: TextFormField(
                                    controller: ownerController,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    obscureText: false,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      labelText: 'Owner',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                      ),
                                    ),
                                    cursorColor: Colors.white,
                                    autovalidate: _autoValidate,
                                    validator: (String value) {
                                      return validateInput(value);
                                    },
                                  )),
                              SizedBox(height: 10),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: TextFormField(
                                    controller: categoryController,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    obscureText: false,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      labelText: 'Category',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                      ),
                                    ),
                                    cursorColor: Colors.white,
                                    autovalidate: _autoValidate,
                                    validator: (String value) {
                                      return validateInput(value);
                                    },
                                  )),
                              SizedBox(height: 10),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: TextFormField(
                                    controller: locationController,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    obscureText: false,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      labelText: 'Location',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                      ),
                                    ),
                                    cursorColor: Colors.white,
                                    autovalidate: _autoValidate,
                                    validator: (String value) {
                                      return validateInput(value);
                                    },
                                  )),
                              SizedBox(height: 10),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: TextFormField(
                                    controller: phoneController,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    obscureText: false,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                      ),
                                    ),
                                    cursorColor: Colors.white,
                                    autovalidate: _autoValidate,
                                    validator: (String value) {
                                      return validatePhoneNumber(value);
                                    },
                                  )),
                            ]),
                        SizedBox(height: 10),
                        Row(children: <Widget>[
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 24),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              onPressed: () {
                                onDonePress(context);
                              },
                              padding: EdgeInsets.all(12),
                              color: Colors.white,
                              child: createProgress
                                  ? JumpingText("Creating...",
                                      style: TextStyle(color: Colors.blueGrey))
                                  : Text('Create Advert',
                                      style: TextStyle(color: Colors.blueGrey)),
                            ),
                          ))
                        ])
                      ],
                    )))));
  }

  //image uploader
  Widget profileImageUploader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          child: Container(
              width: 90.0,
              height: 90.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(80.0),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(80.0),
                  child: FittedBox(
                    child: imageFile == null
                        ? Image.asset('assets/images/app_logo.png')
                        : new Image.file(this.imageFile, scale: 1.0),
                    fit: BoxFit.cover,
                  ))),
          onTap: () {
            _showImageDialog(context);
          },
        ),
        // onTap: _showImageDialog

        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text('Upload Image',
                style: TextStyle(
                    //decoration: TextDecoration.underline,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ),
          onTap: () {
            _showImageDialog(context);
          },
        ),
        this.imageEmpty
            ? Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 10),
            child: Text("*Please upload an image",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 14)))
            : Text(""),
      ],
    );
  }

  //For picking image
  Future<File> _pickImage(String action) async {
    PickedFile selectedImage;
    ImagePicker picker = ImagePicker();
    File selectedFile;

    action == 'Gallery'
        ? selectedImage = await picker.getImage(source: ImageSource.gallery)
        : selectedImage = await picker.getImage(source: ImageSource.camera);

    selectedFile = File(selectedImage.path);
    return selectedFile;
  }

  _showImageDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Choose from Gallery'),
                onPressed: () {
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    //compressImage();

                    Navigator.pop(context);
                    // _repository.uploadImageToStorage(imageFile).then((url) {
                    //   _repository.updatePhoto(url, currentUser.uid).then((v) {
                    //     Navigator.pop(context);
                    //   });
                    // }

                    // );
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () {
                  _pickImage('Camera').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    //compressImage();
                    Navigator.pop(context);
                    // _repository.uploadImageToStorage(imageFile).then((url) {
                    //   _repository.updatePhoto(url, currentUser.uid).then((v) {
                    //     Navigator.pop(context);
                    //   });
                    // });
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  //validate full name entered by user
  String validateInput(String value) {
    String pattern = r'(^[a-zA-z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Input is required";
    }
    return null;
  }

  //validate phone number
  String validatePhoneNumber(String value) {
    String pattern = r'(^[+0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Phone number is required";
    } else if (!regExp.hasMatch(value)) {
      return "Phone number must only be digits";
    } else if (value.length < 9) {
      return "Please enter a valid phone number";
    }
    return null;
  }

  //when user finishes the slide
  void onDonePress(BuildContext context) async {
    Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_key.currentState.validate() && imageFile != null) {
      setState(() {
        createProgress = true;
      });
      dio.options.headers =  {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer " + prefs.getString('Token')
      };
      String fileName = imageFile.path.split('/').last;
      FormData data = new FormData.fromMap({
        "title": titleController.text,
        "description": descriptionController.text,
        "owner": ownerController.text,
        "category" : categoryController.text,
        "location" : locationController.text,
        "phoneNumber" :phoneController.text.toString(),
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });
     var response = await retry(
        // Make a GET request
            () => dio.post("$baseApi/adverts",data: data)
        .catchError((error) => print(error.toString()))
            .timeout(Duration(seconds: 10)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      if(response.statusCode == 201){
        Navigator.pushNamed(context, "/home");
      }

    } else {
      setState(() {
        _autoValidate = true;
      });
      if(imageFile == null){
        setState(() {
          imageEmpty = true;
        });
      }
    }
  }
}
