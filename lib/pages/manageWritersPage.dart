import '../widgets/writerWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/advertisingBlogBloc.dart';
import '../repository/blogRepo.dart';

class ManageWritersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ManageWritersPageState();
  }
}

class ManageWritersPageState extends State<ManageWritersPage> {
  BlogBloc blocBlog;
  SharedPreferences prefs;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    blocBlog = new BlogBloc(bRepo: new BlogRepo());
    blocBlog.writerActionSink.add(Fetchwriters());
    initializeSharedPreferences();
  }

  Future<void> refresh() async {
    blocBlog.writerActionSink.add(Reloadblogs());
  }

  initializeSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      prefs = sharedPreferences;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text("Writers"),
              centerTitle: true,
              backgroundColor: Colors.blueGrey[800],
            ),
            body: RefreshIndicator(
                onRefresh: refresh,
                child: StreamBuilder(
                  stream: blocBlog.writerStream,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      return snapshot.data.length == 0
                          ? Center(
                              child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.people_outline,
                                                size: 80,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            Text("No writers yet!",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ))
                                          ]))))
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 2),
                              decoration:
                                  BoxDecoration(color: Colors.blueGrey[50]),
                              child: ListView.separated(
                                //key: animatedListKey,
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return WriterWidget(
                                      writer: snapshot.data[index]);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider(color: Colors.blueGrey[300]);
                                },
                              ));
                    } else if (snapshot.hasError) {
                      return Container(
                          margin: EdgeInsets.only(top: 100),
                          child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.error,
                                        size: 80, color: Colors.red),
                                    Text(
                                        "Sorry, couldn't connect to Server. Please refresh the page!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.red,
                                        ))
                                  ])));
                    }
                    return Container(
                        margin: EdgeInsets.only(top: 100),
                        child: Align(
                            alignment: Alignment.center,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.error,
                                      size: 80, color: Colors.red),
                                  Text(
                                    "",
                                  )
                                ])));
                  },
                ))));
  }
}
