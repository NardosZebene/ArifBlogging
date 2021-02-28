import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/blog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:retry/retry.dart';
import 'dart:io';
import 'dart:async';
import '../models/writer.dart';
import '../utilities/constants.dart';


class BlogRepo {
  //get the list of movies
  getBlogs() async {
    var headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      // "Authorization": "Bearer " + prefs.getString('Token')
    };
    var response = await retry(
      () => http
          .get(
              "$baseApi/adverts",
              headers: headers)
          .timeout(Duration(seconds: 10)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    print(response);
    List<Blog> blogList = [];
    if (response.statusCode == 200) {
      var blogListResponse = json.decode(response.body);
      for(int index = 0; index < blogListResponse.length; index++){
        Blog blg = Blog.fromJson(blogListResponse[index]);
        blogList.add(blg);
      }

    } else {
      print("Status code fail " + response.statusCode.toString());
    }
    return blogList;
  }

  getSearchedBlogs(String searched) async {
    var headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      // "Authorization": "Bearer " + prefs.getString('Token')
    };
    var response = await retry(
          () => http
          .get(
          "$baseApi/adverts/search?title=$searched",
          headers: headers)
          .timeout(Duration(seconds: 10)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    List<Blog> blogList = [];
    if (response.statusCode == 200) {
      var blogListResponse = json.decode(response.body);
      for(int index = 0; index < blogListResponse.length; index++){
        Blog blg = Blog.fromJson(blogListResponse[index]);
        blogList.add(blg);
      }

    } else {
      print("Status code fail " + response.statusCode.toString());
    }
    return blogList;
  }

  //get the list of writers
  getWriterList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer " + prefs.getString('Token')
    };
    var response = await retry(
          () => http
          .get(
          "$baseApi/accounts",
          headers: headers)
          .timeout(Duration(seconds: 10)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    List<Writer> writerList = [];
    if (response.statusCode == 200) {
      var writerListResponse = json.decode(response.body);
      for(int index = 0; index < writerListResponse.length; index++){
        Writer writer = Writer.fromJson(writerListResponse[index]);
        writerList.add(writer);
      }

    } else {
      print("Status code fail " + response.statusCode.toString());
    }
    return writerList;
  }
  //delete a writer
  deleteWriter(String writerId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer " + prefs.getString('Token')
    };
    var response = await retry(
          () => http
          .delete(
          "$baseApi/accounts/$writerId",
          headers: headers)
          .timeout(Duration(seconds: 10)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    print(response.body);
    return response.statusCode;
  }
  //delete a blog
  deleteBlog(String blogId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer " + prefs.getString('Token')
    };
    var response = await retry(
          () => http
          .delete(
          "$baseApi/adverts/$blogId",
          headers: headers)
          .timeout(Duration(seconds: 10)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    print(response);
    return response.statusCode;
  }
}
