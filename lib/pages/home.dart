import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view_model/advertisingBlogBloc.dart';
import '../repository/blogRepo.dart';
import '../widgets/blogWidget.dart';
import 'postAdvert.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  BlogBloc blocBlog;
  SharedPreferences prefs;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    blocBlog = new BlogBloc(bRepo: new BlogRepo());
    blocBlog.actionSink.add(Fetchblogs());
    initializeSharedPreferences();
  }

  Future<void> refresh() async {
    blocBlog.actionSink.add(Reloadblogs());
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
            drawer: Drawer(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Text('Ethio Advertising',
                        style: TextStyle(color: Colors.white, fontSize: 25)),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  prefs != null && prefs.getString('Token') != null
                      ? ListTile(
                          title: Text('Sign Out',
                              style: TextStyle(
                                  color: Colors.blueGrey[800], fontSize: 15)),
                          onTap: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            await preferences.clear();
                            Navigator.pushNamed(context, '/home');
                          },
                        )
                      : ListTile(
                          title: Text('Sign In',
                              style: TextStyle(
                                  color: Colors.blueGrey[800], fontSize: 15)),
                          onTap: () {
                            Navigator.pushNamed(context, '/signIn');
                          },
                        ),
                  Divider(),
                  prefs != null && prefs.getString('Token') != null
                      ? ListTile(
                          title: Text('Post Advert',
                              style: TextStyle(
                                  color: Colors.blueGrey[800], fontSize: 15)),
                          onTap: () {
                            Navigator.pushNamed(context, '/postAdvert');
                          },
                        )
                      : Text(""),
                  prefs != null &&
                          prefs.getString('Role') != null &&
                          prefs.getString('Role') == "admin"
                      ? ListTile(
                          title: Text('Manage Writers',
                              style: TextStyle(
                                  color: Colors.blueGrey[800], fontSize: 15)),
                          onTap: () {
                            Navigator.pushNamed(context, '/manageWriters');
                          },
                        )
                      : Text(""),
                ],
              ),
            ),
            appBar: AppBar(
              title: Text("Ethio Advertising"),
              centerTitle: true,
              backgroundColor: Colors.blueGrey[800],
              leading: new IconButton(
                icon: new Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState.openDrawer(),
              ),
            ),
            body: RefreshIndicator(
                onRefresh: refresh,
                child: StreamBuilder(
                  stream: blocBlog.blogStream,
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
                                            Icon(Icons.notifications,
                                                size: 80,
                                                color: Colors.blueGrey),
                                            Text("No adverts yet!",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.blueGrey,
                                                ))
                                          ]))))
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 2),
                              decoration:
                                  BoxDecoration(color: Colors.blueGrey[50]),
                              child: ListView.builder(
                                //key: animatedListKey,
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return BlogWidget(blog: snapshot.data[index]);
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
