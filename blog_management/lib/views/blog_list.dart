import 'package:blog_management/ui/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_management/viewmodels/blog_list_viewmodel.dart';
import '../models/blogs.dart';


class BlogList extends StatefulWidget {
  const BlogList({super.key, required this.title});
  final String title;

  @override
  State<BlogList> createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {
  final BlogListCubit blocListCubit = BlogListCubit();
  final PageCounterCubit pageCounterCubit = PageCounterCubit(maxCounter: 1);
  final TextEditingController _searchController = TextEditingController();
  final EntryLimitCubit entryLimitCubit = EntryLimitCubit();

  void fetchBlogs() async{
    blocListCubit.state.clear();
    List<Blog>? blogs = await Blog.fetchBlogs(
      limit: entryLimitCubit.state,
      page: pageCounterCubit.state,
      search: _searchController.text.toString()
    );

    if (blogs != null){
      for (Blog blog in blogs){
        blocListCubit.addBlog(blog);
      }
    }

    pageCounterCubit.updateMaxCounter(99);
  }

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);

    return Scaffold(
      body: Container(
            padding: const EdgeInsets.all(10),
            color: Colors.grey[200],
            height: ScreenSize.screenHeight!,
            width: ScreenSize.screenWidth!,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                      color: Colors.white,
                    ),
                    child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: ScreenSize.screenHeight! * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 2.5),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(1), bottomRight: Radius.circular(1)),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text('show', style: TextStyle(fontSize: ScreenSize.screenHeight! * 0.015),),
                              const SizedBox(width: 10),
                              BlocBuilder<EntryLimitCubit, int>(
                                bloc: entryLimitCubit,
                                builder: (BuildContext context, int limit) {
                                  return DropdownButton(
                                    value: limit,
                                    items: List.generate(10, (index) => index + 1).map((value) {
                                      return DropdownMenuItem(
                                          value: value,
                                          child: Text('$value'),
                                        );
                                      }).toList(),
                                    onChanged: <int>(value){
                                      entryLimitCubit.updateLimit(value);
                                      fetchBlogs();
                                    },
                                  );
                                }
                              ),
                              const SizedBox(width: 10),
                              Text('entries', style: TextStyle(fontSize: ScreenSize.screenHeight! * 0.015),),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Text('Search', style: TextStyle(fontSize: ScreenSize.screenHeight! * 0.015),),
                              const SizedBox(width: 10),
                              // create a searchbar
                              Container(
                                width: ScreenSize.screenWidth! * 0.25,
                                height: ScreenSize.screenHeight! * 0.04,
                                child: TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                                  ),
                                  onSubmitted: (String value){
                                    fetchBlogs();
                                  },
                                ),
                              )
                            ],
                          )
                        ),
                      ],
                    )
                  ),
                  BlocBuilder<BlogListCubit, List<Blog>>(
                    bloc: blocListCubit,
                    builder: (BuildContext context, List<Blog> blogs){
                      return DataTable(
                        headingRowColor: WidgetStateProperty.resolveWith((states) => Color.fromRGBO(240, 239, 244, 1)),
                        dataRowColor: WidgetStateProperty.resolveWith((states) => Colors.white),
                        dataRowMaxHeight: double.infinity,
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Title')),
                          DataColumn(label: Text('Body')),
                          ], 
                        rows: [
                          for (var blog in blogs)
                            DataRow(cells: [
                              DataCell(Text(blog.id.toString())),
                              DataCell(Text(blog.title!)),
                              DataCell(Text(blog.body!)),
                            ]),
                          ],
                      );
                    } 
                  ),
                  BlocBuilder<PageCounterCubit, int>(
                    bloc: pageCounterCubit,
                    builder: (BuildContext context, int counter) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        height: ScreenSize.screenHeight! * 0.075,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              style: IconButton.styleFrom(backgroundColor: const Color.fromRGBO(240, 239, 244, 1),),
                              icon: const Icon(Icons.chevron_left,),
                              onPressed: () {
                                pageCounterCubit.back();
                                fetchBlogs();
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: (8.0)),
                              child: IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: const Color.fromRGBO(100, 92, 230, 1),
                                ),
                                icon: Text('$counter', 
                                  style: const TextStyle(fontWeight: FontWeight.bold, color:Colors.white),
                                ),
                                onPressed: () {},
                              ),
                            ),
                            IconButton(
                              style: IconButton.styleFrom(backgroundColor: const Color.fromRGBO(240, 239, 244, 1),),
                              icon: const Icon(Icons.chevron_right),
                              onPressed: () {
                                pageCounterCubit.next();
                                fetchBlogs();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          )
    );
  }
}
