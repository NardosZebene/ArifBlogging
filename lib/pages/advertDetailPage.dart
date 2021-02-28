import 'package:flutter/material.dart';
import '../models/blog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';

class AdvertDetail extends StatefulWidget {
  AdvertDetail({Key key, this.blog}) : super(key: key);
  Blog blog;

  @override
  _AdvertDetailState createState() => _AdvertDetailState(this.blog);
}

class _AdvertDetailState extends State<AdvertDetail> {
  Blog blog;
  _AdvertDetailState(this.blog);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(blog.title),
            centerTitle: true,
            backgroundColor: Colors.blueGrey[800],
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: <Widget>[
              //top image
              topAdvertImage(),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
                SizedBox(
                  height: 10,
                ),
                //movie title
                Text(this.blog.title,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text("Location : " + this.blog.location,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 15)),
                Text("Phone number : " + this.blog.phoneNumber,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 15)),
                SizedBox(height: 10),
                //rate,time and 3d
                Divider(
                  color: Colors.grey,
                  height: 1,
                ),
                SizedBox(height: 10),
                //
                SizedBox(height: 10),
                // Synopsis
                Text(blog.description),
                //Calendar
                SizedBox(height: 10),
                //
              ])
            ],
          ),
        ));
  }

  //movie image builder
  topAdvertImage() {
    return Container(
        margin: EdgeInsets.only(bottom: 10, top: 10),
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: FittedBox(
              child: CachedNetworkImage(
                imageUrl: blog.image,
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, size: 18),
              ),
              fit: BoxFit.cover,
            )));
  }
  //calendar date widget
}