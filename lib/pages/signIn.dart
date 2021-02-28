import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:retry/retry.dart';
import 'dart:io';
import 'dart:async';
import '../utilities/constants.dart';


class SigninPage extends StatefulWidget {
  BuildContext context;
  SigninPage({this.context});
  @override
  SigninPageState createState() => new SigninPageState(this.context);
}

class SigninPageState extends State<SigninPage> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _autoValidate = false; //flag for automatic validation
  String user_id, user_password;
  bool showProgress = false;
  bool wrongCredentials = false;
  BuildContext parentContext;

  SigninPageState(this.parentContext);

  @override
  Widget build(parentContext) {
    //Logo
    final logo = Image(
      image: AssetImage('assets/images/app_logo.png'),
      width: 60,
      height:60,
    );
    //Title
    final title = Container(
      margin: const EdgeInsets.only(top: 20),
      child: Text(
        'Sign In',
        style: TextStyle(
          fontSize: 22,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
    //User Id
    final userId = TextFormField(
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        labelText: 'User ID',
        hintText: 'Email or Phone Number',
        helperText: 'Enter your email',
        helperStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white),
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
        return validateUserId(value);
      },
      onSaved: (String value) {
        setState(() {
          user_id = value;
        });
      },
    );
    //Password
    final password = TextFormField(
      style: TextStyle(
        color: Colors.white,
      ),
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        helperText: 'Enter your password',
        helperStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white),
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
          user_password = value;
        });
      },
    );
    //wrong credintials are entered
    final wrongCredentials = Text(
      "Wrong Username or password, please try again!",
      style: TextStyle(color: Colors.red),
    );
    //Log in button
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          setState(() {
            showProgress = true;
          });
          sendToServer();
        },
        padding: EdgeInsets.all(12),
        child: showProgress
            ? JumpingText("Signing in...", style: TextStyle(color: Colors.blueGrey))
            : Text('Sign in', style: TextStyle(color: Colors.blueGrey)),
      ),
    );
    //Redirects user to sign up if user hasn't registered yet
    final havenotRegisterdLabel = FlatButton(
      child: Text(
        'Haven\'t registered yet ? Sign up',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/signUp');
      },
    );
    var sizeH = MediaQuery
        .of(context)
        .size
        .height;
    var sizeW = MediaQuery
        .of(context)
        .size
        .width;
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return;
        },
        child: Scaffold(
            body: Container(
                padding: const EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blueGrey[800], Colors.blueGrey[100]],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
                child: Center(
                    child: Form(
                      key: _key,
                      child: ListView(
                        padding: EdgeInsets.only(left: 24.0, right: 24.0),
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child : Align(
                                  alignment: Alignment.centerLeft,
                                  child : Icon(Icons.arrow_back_ios,color:Colors.white,))),
                          SizedBox(height: 40.0),
                          logo,
                          title,
                          SizedBox(height: 8.0),
                          // SizedBox(
                          //   height: 40,
                          //   child :title),
                          SizedBox(height: 8.0),
                          userId,
                          SizedBox(height: 8.0),
                          password,
                          SizedBox(height: 8.0),
                          this.wrongCredentials ? wrongCredentials : Text(""),
                          SizedBox(height: 8.0),
                          loginButton,
                          havenotRegisterdLabel,
                        ],
                      ),
                    )))));
  }

  //validate user id
  String validateUserId(String value) {
    if (value.length == 0) {
      return "User ID is required";
    }
    return null;
  }

  //validate password
  String validatePassword(String value) {
    if (value.length == 0) {
      return "Password is required";
    } else if (value.length < 6) {
      return "Password is atleast be 6 characters";
    } else if (value.length > 15) {
      return "Password is no morethan 15 characters";
    }
    return null;
  }

  //sends data to server
  sendToServer() async {
    if (_key.currentState.validate()) {
      await _key.currentState.save();
      var headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await retry(
        // Make a GET request
            () =>
            http
                .post("$baseApi/accounts/login",
                headers: headers,
                body:
                json.encode({"email": user_id, "password": user_password}))
                .timeout(Duration(seconds: 10)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      print(response.body.toString());
      if (response.statusCode == 201) {
        await prefs.setString('Token', json.decode(response.body)['token']);
        await prefs.setString(
            'Email', json.decode(response.body)['accountInfo']['email']);
        await prefs.setString(
            'FirstName', json.decode(response.body)['accountInfo']['firstName']);
        await prefs.setString(
            'LastName', json.decode(response.body)['accountInfo']['lastName']);
        await prefs.setString(
            'UserId', json.decode(response.body)['accountInfo']['_id']);
        await prefs.setString(
            'Role', json.decode(response.body)['accountInfo']['role']);
        setState(() {
          showProgress = false;
          wrongCredentials = false;
        });
        //if sign-in is successful
        Navigator.pushNamed(context, '/home');
      } else {
        setState(() {
          showProgress = false;
        });
        if (response.body == "Incorrect user information") {
          setState(() {
            wrongCredentials = true;
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