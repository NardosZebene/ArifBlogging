import 'package:flutter/cupertino.dart';

import '../models/blog.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../pages/advertDetailPage.dart';


class BlogWidget extends StatefulWidget {
  final Blog blog;

  BlogWidget({@required this.blog});

  @override
  _BlogWidgetState createState() => _BlogWidgetState(
        blog: this.blog,
      );
}

class _BlogWidgetState extends State<BlogWidget> {
  _BlogWidgetState({this.blog});

  //Reply sampleReply;
  Blog blog;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdvertDetail(blog: this.blog),
            ),
          );
        },
        child: Card(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 5),
                  Container(
                      child: Text(
                        blog.owner,
                        style: TextStyle(
                            color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold),
                      )),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 90,
                        height: 100,
                        margin: EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: FittedBox(
                            child: CachedNetworkImage(
                          imageUrl: blog.image,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error, size: 18),
                          fit: BoxFit.contain,
                        )),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              blog.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              blog.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10)
                ],
              )),
        ));
  }
}
