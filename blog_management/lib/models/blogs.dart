import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


class Blog {
  int? id;
  String? title;
  String? body;

  Blog({
    required this.id,
    required this.title,
    required this.body
  });

  @override
  String toString(){
    return title ?? '';
    
  }

  factory Blog.fromJson(Map<String, dynamic> json) {
    return  Blog(
      id: json['id'],
      title: json['title'],
      body: json['body']
    );
  } 

  // Function to fetch the blogs
  static Future<List<Blog>?> fetchBlogs({int limit = 1, int page = 1,
  String search = ''}) async{
    final dio = Dio();
    Response response;
    response = await dio.get('https://jsonplaceholder.typicode.com/posts');

    if (response.statusCode == 200){
      // Create the list of blogs
      List<Blog> blogs = List.from(response.data.map((blog) => Blog.fromJson(blog)));

      // Simulate the search filter
      blogs = blogs.where((Blog blog) =>
        blog.title!.contains(search) || blog.body!.contains(search)).toList();

      // Simulate a page filtering by filtering the retrieved data
      int from = (limit * page) - (limit - 1);
      int to = page * limit < blogs.length ? page * limit : blogs.length;

      return blogs.sublist(from-1, to);
    }
    return null;
  }
}