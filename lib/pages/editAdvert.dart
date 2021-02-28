import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:retry/retry.dart';
import 'package:dio/dio.dart';
import '../utilities/constants.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import '../models/blog.dart';


class EditAdvertPage extends StatefulWidget {
  Blog blog;
  EditAdvertPage({this.blog});
  @override
  _EditAdvertPageState createState() => _EditAdvertPageState(blog: this.blog);
}

class _EditAdvertPageState extends State<EditAdvertPage> {
  Blog blog;
  _EditAdvertPageState({this.blog});
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
  void initState() {
    super.initState();
    descriptionController.text = blog.description;
    locationController.text = blog.location;
    ownerController.text = blog.owner;
    titleController.text = blog.title;
    phoneController.text = blog.phoneNumber;
    categoryController.text = blog.category;
  }


  @override
  Widget build(BuildContext context) {
    var sizeW = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Edit Advert"),
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
                                      ? JumpingText("Updating...",
                                      style: TextStyle(color: Colors.blueGrey))
                                      : Text('Update Advert',
                                      style: TextStyle(color: Colors.blueGrey)),
                                ),
                              ))
                        ])
                      ],
                    )))));
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
    if (_key.currentState.validate()) {
      setState(() {
        createProgress = true;
      });
      var headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer " + prefs.getString('Token')
      };
      var response = await retry(
            () => http
            .put(
            "$baseApi/adverts/${blog.id}",
            headers: headers,
            body: jsonEncode({
              "title": titleController.text,
              "description": descriptionController.text,
              "category" : categoryController.text,
              "location" : locationController.text,
              "phoneNumber" :phoneController.text.toString(),
            })
            )
            .timeout(Duration(seconds: 10)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      print(jsonDecode(response.body));
      if(response.statusCode == 200){
        Navigator.pushNamed(context, "/manageAdverts");
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
