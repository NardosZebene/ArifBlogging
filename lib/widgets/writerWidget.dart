import '../models/writer.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../repository/blogRepo.dart';

class WriterWidget extends StatefulWidget {
  final Writer writer;
  WriterWidget({@required this.writer});
  @override
  _WriterWidgetState createState() =>
      _WriterWidgetState(writer: this.writer);
}

class _WriterWidgetState extends State<WriterWidget> {
  _WriterWidgetState({this.writer});
  Writer writer;
  bool deleteProgress = false;
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
    return ListTile(
      leading: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: CircleAvatar(
                  backgroundImage:
                  AssetImage('assets/images/app_logo.png'),
                  maxRadius: 40,
                )),
      title: Text(writer.firstName + " " + writer.lastName),
      trailing: FlatButton(
        child: Container(
            height: 25,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 5, vertical: 5),
                child: this.deleteProgress
                    ? JumpingText("...",
                    style: TextStyle(
                        color: Colors.blueGrey))
                    : Text(
                   "Delete Writer",
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12),
                ))),
        onPressed: () async {
          setState(() {
            deleteProgress = true;
          });
          var responseStatusCode = await blogRepo.deleteWriter(this.writer.id);
          if(responseStatusCode == 200){
            Navigator.pushNamed(context, "/manageWriters");
          }
          setState(() {
            deleteProgress = false;
          });

        },
      ),

    );
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
