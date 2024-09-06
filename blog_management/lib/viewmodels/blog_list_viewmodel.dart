import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_management/models/blogs.dart';

class BlogListCubit extends Cubit<List<Blog>>{
  BlogListCubit() : super([]);

  void addBlog(Blog blog){
    state.add(blog);
    emit(List.from(state));
  }
}


class PageCounterCubit extends Cubit<int> {
  int maxCounter = 1;
  PageCounterCubit({required this.maxCounter}) : super(1);

  void next() => state == maxCounter ? emit(state) : emit(state + 1);
  void back() => state == 1 ? emit(1) : emit(state - 1);

  void jumpToPage(int page){
    if ((page >= 1) & (page <= maxCounter)){
      emit(page);
    }
    else{
      emit(state);
    }
  }

  void updateMaxCounter(int newMaxCounter){
    maxCounter = newMaxCounter;
    emit(state);
  }
}


class EntryLimitCubit extends Cubit<int>{
  EntryLimitCubit() : super(10);

  void updateLimit(int newLimit){
    emit(newLimit);
  }
}