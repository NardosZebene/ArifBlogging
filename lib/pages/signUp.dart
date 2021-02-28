import 'package:flutter/material.dart';

import 'signIn.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:retry/retry.dart';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/constants.dart';

class SignUpPage extends StatefulWidget {
  static String tag = 'sign-up-page';
  String firstName;
  String lastName;
  String email;

  SignUpPage({this.firstName, this.lastName, this.email});

  @override
  State<StatefulWidget> createState() {
    return SignUpPageState(
        firstName: this.firstName, lastName: this.lastName, email: this.email);
  }
}

class SignUpPageState extends State<SignUpPage> {
  SignUpPageState({this.firstName, this.lastName, this.email});
  GlobalKey<FormState> _key = new GlobalKey();
  String firstName = "";
  String lastName = "";
  String email = "";
  String password = "";
  bool showProgress = false;
  bool userAlreadyExist = false;
  bool _autoValidate = false; //flag for automatic validation
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Logo
    final logo = Image(
      image: AssetImage('assets/images/app_logo.png'),
      width: 60,
      height: 60,
    );
    //Title
    final title = Container(
      margin: const EdgeInsets.only(top: 20),
      child: Text(
        'Create Your Account',
        style: TextStyle(
          fontSize: 22,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
    //Full name
    final firstNameWidget = TextFormField(
      style: TextStyle(
        color: Colors.white,
      ),
      controller: firstNameController,
      decoration: InputDecoration(
        labelText: 'First Name',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: const UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 0.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 0.0),
        ),
      ),
      cursorColor: Colors.white,
      //validating user input
      autovalidate: _autoValidate,
      validator: (String value) {
        return validateFullName(value);
      },
      onSaved: (String value) {
        setState(() {
          firstName = value;
        });
      },
    );
    final lastNameWidget = TextFormField(
      style: TextStyle(
        color: Colors.white,
      ),
      controller: lastNameController,
      decoration: InputDecoration(
        labelText: 'Last Name',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: const UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 0.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 0.0),
        ),
      ),
      cursorColor: Colors.white,
      //validating user inputs
      autovalidate: _autoValidate,
      validator: (String value) {
        return validateFullName(value);
      },
      onSaved: (String value) {
        setState(() {
          lastName = value;
        });
      },
    );
    //Email
    final emailWidget = TextFormField(
      style: TextStyle(
        color: Colors.white,
      ),
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      maxLength: 30,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: const UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 0.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 0.0),
        ),
      ),
      cursorColor: Colors.white,
      //validating user input
      autovalidate: _autoValidate,
      validator: (String value) {
        return validateEmail(value);
      },
      onSaved: (String value) {
        setState(() {
          email = value;
        });
      },
    );
    //Password
    final passwordWidget = TextFormField(
      style: TextStyle(
        color: Colors.white,
      ),
      maxLength: 15,
      obscureText: true,
      controller: passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: const UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 0.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 0.0),
        ),
      ),
      cursorColor: Colors.white,
      //validating user input
      autovalidate: _autoValidate,
      validator: (String value) {
        return validatePassword(value);
      },
      onSaved: (String value) {
        setState(() {
          password = value;
        });
      },
    );
    //wrong credintials are entered
    final wrongInput = Text(
      "User already exists, please try again!",
      style: TextStyle(color: Colors.red),
    );
    //Sign up button
    final signUpButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          setState(() {
            showProgress = true;
          });
          sendToserver();
        },
        padding: EdgeInsets.all(12),
        color: Colors.white,
        child: showProgress
            ? JumpingText("Signing up...",
                style: TextStyle(color: Colors.blueGrey))
            : Text('Sign up', style: TextStyle(color: Colors.blueGrey)),
      ),
    );
    //Redirects user to sign in if user has already account
    final alreadyHaveAccountLabel = FlatButton(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Already have an account ? ',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              decoration: TextDecoration.underline),
        ),
        Text("Sign in",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                decoration: TextDecoration.underline))
      ]),
      onPressed: () {
        Navigator.pushNamed(context, '/signIn');
      },
    );
    var sizeH = MediaQuery.of(context).size.height;
    var sizeW = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return;
        },
        child: SafeArea(
            child: Scaffold(
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
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ))),
                    SizedBox(height: 30.0),
                    logo,
                    title,
                    SizedBox(height: 15.0),
                    firstNameWidget,
                    lastNameWidget,
                    emailWidget,
                    passwordWidget,
                    SizedBox(
                      height: 8.0,
                    ),
                    SizedBox(height: 8.0),
                    this.userAlreadyExist ? wrongInput : Text(""),
                    SizedBox(height: 10.0),
                    signUpButton,
                  ],
                ),
              )),
        )));
  }

  //validate full name entered by user
  String validateFullName(String value) {
    String pattern = r'(^[a-zA-z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Full name is required";
    } else if (!regExp.hasMatch(value)) {
      return "Please enter a valid name";
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
    } else if (value.length < 13) {
      return "Please enter a valid phone number";
    }
    return null;
  }

  //vlidate email
  String validateEmail(String value) {
    String pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is required";
    } else if (!regExp.hasMatch(value)) {
      return "In appropriate email address";
    }
    return null;
  }

  //validate password
  String validatePassword(String value) {
    if (value.length == 0) {
      return "Password is required";
    } else if (value.length < 6) {
      return "Password should atleast be 6 characters";
    }
    return null;
  }

  //sends data to server
  sendToserver() async {
    if (_key.currentState.validate()) {
      await _key.currentState.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      CircularProgressIndicator();
      final String url = "$baseApi/accounts";
      //print("User entries " + user_password+ "," +user_email+ "," +user_phoneNumber+ "," +user_fullName);
      var headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };
      var response = await retry(
        // Make a GET request
        () => http
            .post(url,
                headers: headers,
                body: json.encode({
                  "password": passwordController.text,
                  "email": emailController.text,
                  "firstName": firstNameController.text,
                  "lastName": lastNameController.text,
                  "role": "writer"
                }))
            .timeout(Duration(seconds: 10)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      print(response.body);

      if (response.statusCode == 201) {
        await prefs.setString('Token', json.decode(response.body)['token']);
        await prefs.setString(
            'Email', json.decode(response.body)['accountInfo']['email']);
        await prefs.setString('FirstName',
            json.decode(response.body)['accountInfo']['firstName']);
        await prefs.setString(
            'LastName', json.decode(response.body)['accountInfo']['lastName']);
        await prefs.setString(
            'UserId', json.decode(response.body)['accountInfo']['_id']);
        await prefs.setString(
            'Role', json.decode(response.body)['accountInfo']['role']);
        //if sign-up is successful

        setState(() {
          showProgress = false;
          userAlreadyExist = false;
        });
        Navigator.pushNamed(context, '/home');
      } else {
        setState(() {
          showProgress = false;
        });
        if (response.statusCode == 403) {
          setState(() {
            userAlreadyExist = true;
          });
        }
      }
    } else {
      setState(() {
        _autoValidate = true;
        showProgress = false;
      });
    }
  }
}
