import 'dart:async';
import 'package:equatable/equatable.dart';
import '../models/blog.dart';
import '../repository/blogRepo.dart';
import '../models/writer.dart';


class BlogEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Fetchblogs extends BlogEvent {
  @override
  List<Object> get props => [];
}

class Fetchwriters extends BlogEvent {
  @override
  List<Object> get props => [];
}

class Reloadblogs extends BlogEvent {
  @override
  List<Object> get props => [];
}

class BlogBloc {
  List<Blog> blogs;
  List<Writer> writers;

  // blog controllers
  StreamController _blogStreamController = StreamController<List<Blog>>();

  StreamSink<List<Blog>> get _blogSink => _blogStreamController.sink;

  Stream<List<Blog>> get blogStream => _blogStreamController.stream;

  //blog action controllers
  StreamController _actionStreamController = StreamController<BlogEvent>();

  StreamSink<BlogEvent> get actionSink => _actionStreamController.sink;

  Stream<BlogEvent> get _actionStream => _actionStreamController.stream;

  // writer controllers
  StreamController _writerStreamController = StreamController<List<Writer>>();

  StreamSink<List<Writer>> get _writerSink => _writerStreamController.sink;

  Stream<List<Writer>> get writerStream => _writerStreamController.stream;

  //writer action controllers
  StreamController _writerActionStreamController = StreamController<
      BlogEvent>();

  StreamSink<BlogEvent> get writerActionSink =>
      _writerActionStreamController.sink;

  Stream<BlogEvent> get _writerActionStream =>
      _writerActionStreamController.stream;

  BlogRepo blogRepo;

  BlogBloc({BlogRepo bRepo}) {
    blogRepo = bRepo;
    _actionStream.listen((event) async {
      if (event is Fetchblogs) {
        try {
          blogs = await blogRepo.getBlogs();
          _blogSink.add(blogs);
        } on Exception catch (e) {
          _blogSink.addError("Couldn't connect to server");
        }
      } else if (event is Reloadblogs) {
        blogs = [];
        _blogSink.add(null);
      }
    });
    _writerActionStream.listen((event) async {
      if (event is Fetchwriters) {
        try {
          writers = await blogRepo.getWriterList();
          _writerSink.add(writers);
        } on Exception catch (e) {
          _writerSink.addError("Couldn't connect to server");
        }
      }else if (event is Reloadblogs) {
        blogs = [];
        _writerSink.add(null);
      }
    });

    //closing stream
    void dispose() {
      _blogStreamController.close();
      _actionStreamController.close();
      _writerActionStreamController.close();
      _writerStreamController.close();
    }
  }
}
