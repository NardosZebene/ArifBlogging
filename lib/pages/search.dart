import 'dart:async';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../models/blog.dart';
import '../widgets/blogWidget.dart';
import '../repository/blogRepo.dart';


class SearchBlog extends StatefulWidget {
  SearchBlog({Key key}) : super(key: key);

  @override
  _SearchBlogState createState() => _SearchBlogState();
}

class _SearchBlogState extends State<SearchBlog> {
  String _searchTerm = "";
  BlogRepo repo = BlogRepo();

  Future<List<Blog>> searchBook(String input) async {
    List<Blog> searchedBlogs = await repo.getSearchedBlogs(input);
    return searchedBlogs;
  }

  @override
  Widget build(BuildContext context) {
    var sizeW = MediaQuery.of(context).size.width;
    var sizeH = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return;
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              iconTheme: IconThemeData(
                  color: Colors.blueGrey[800]
              ),
              elevation: 0.0,
              title: searchbar(),
            ),
            body: SingleChildScrollView(
              child: Column(children: <Widget>[
                SizedBox(height: 20),
                Center(
                    child : StreamBuilder<List<Blog>>(
                      stream: Stream.fromFuture(searchBook(_searchTerm)),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Container(
                              height: sizeH / 2,
                              width: sizeW,
                              child: Center(
                                  child: Text(
                                    "Search advert",
                                    style: TextStyle(
                                        color: Colors.blueGrey[800],
                                        fontSize: 18),
                                  )));
                        else {
                          List<Blog> currSearchStuff =
                              snapshot.data;

                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return JumpingText("Searching...",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16));
                            default:
                              if (snapshot.hasError)
                                return new Text('Error: ${snapshot.error}');
                              else
                                return CustomScrollView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  slivers: <Widget>[
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                            (context, index) {
                                          Blog result =
                                          currSearchStuff[index];
                                          return BlogWidget(
                                              blog: result);
                                        },
                                        childCount: currSearchStuff.length ?? 0,
                                      ),
                                    ),
                                  ],
                                );
                          }
                        }
                      },
                    )),
              ]),
            ),
          ),
        ));
  }

  searchbar() {
    return Container(
        height: 45,
        child : Expanded(
              child: Container(
                height: 45,
                decoration: BoxDecoration(),
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      _searchTerm = val;
                    });
                  },
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.blueGrey[800]),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.blueGrey[800]),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    filled: true,
                    fillColor: Colors.white30,
                    hintText: "Search your advert..",
                    prefixIcon: Icon(
                      Icons.search,
                      size: 22,
                      color: Colors.blueGrey[800],
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        gapPadding: 0),
                  ),
                ),
              ),
            ));
  }

}
