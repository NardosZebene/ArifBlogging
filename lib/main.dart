import 'package:flutter/material.dart';
import 'pages/signIn.dart';
import 'pages/home.dart';
import 'pages/signUp.dart';
import 'pages/advertDetailPage.dart';
import 'pages/postAdvert.dart';
import 'pages/manageWritersPage.dart';
import 'pages/search.dart';
import 'pages/manageAdverts.dart';
import 'pages/editAdvert.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: kRouteApp,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

var kRouteApp = <String, WidgetBuilder>{
  "/home": (context) => HomePage(),
  "/signIn": (context) => SigninPage(),
  "/signUp": (context) => SignUpPage(),
  "/blogDetail": (context) => AdvertDetail(),
  "/postAdvert": (context) => PostAdvertPage(),
  "/manageWriters": (context) => ManageWritersPage(),
  "/search": (context) => SearchBlog(),
  "/manageAdverts": (context) => ManageAdvertsPage(),
  "/editAdverts": (context) => EditAdvertPage(),
};
