import 'package:ethio_advertizing/pages/editAdvert.dart';

import '../models/blog.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../repository/blogRepo.dart';

class AdvertWidget extends StatefulWidget {
  final Blog blog;
  AdvertWidget({@required this.blog});
  @override
  _AdvertWidgetState createState() =>
      _AdvertWidgetState(blog: this.blog);
}

class _AdvertWidgetState extends State<AdvertWidget> {
  _AdvertWidgetState({this.blog});
  Blog blog;
  bool progress = false;
  BlogRepo blogRepo = BlogRepo();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child : ListTile(
      title: Text(blog.title),
      trailing:Container(
      width: 200,
    height: 30,
    child : Row(
      children : [
        FlatButton(
          child: Container(
              height: 25,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 5),
                  child: this.progress
                      ? JumpingText("...",
                      style: TextStyle(
                          color: Colors.blueGrey))
                      : Text(
                    "Edit Blog",
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 12),
                  ))),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => EditAdvertPage(
                      blog: this.blog,
                    )));
          },
        ),
        FlatButton(
        child: Container(
            height: 25,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 5, vertical: 5),
                child: this.progress
                    ? JumpingText("...",
                    style: TextStyle(
                        color: Colors.blueGrey))
                    : Text(
                  "Delete Blog",
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12),
                ))),
        onPressed: () async {
          setState(() {
            progress = true;
          });
          print(this.blog.id);
          var responseStatusCode = await blogRepo.deleteBlog(this.blog.id);
          if(responseStatusCode == 200){
            Navigator.pushNamed(context, "/manageAdverts");
          }
          setState(() {
            progress = false;
          });

        },
      )])),

    ));
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
