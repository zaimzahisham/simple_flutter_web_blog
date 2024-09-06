import 'package:dio/dio.dart';


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

  // Function to fetch the blogs
  static Future<List<Blog>?> fetchBlogs({int limit = 1, int page = 1,
  String search = ''}) async{
    final dio = Dio();
    Response response;
    response = await dio.get('https://jsonplaceholder.typicode.com/posts');

    if (response.statusCode == 200){
      // Create the list of blogs
      List<Blog> blogs = [];

      for (var data in response.data){
        blogs.add(Blog(
          id: data['id'],
          title: data['title'],
          body: data['body']
        ));
      }

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