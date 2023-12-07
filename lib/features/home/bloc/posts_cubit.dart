import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:y/data/remote_data_sources/post/post_data_source.dart';
import 'package:y/domain/models/list_model.dart';
import 'package:y/domain/models/post_preview.dart';

sealed class PostsState {}

class PostsInitialState extends PostsState {}

class PostsLoadingState extends PostsState {}

class PostsLoadedState extends PostsState {
  final ListModel<PostPreview> postsInfo;

  PostsLoadedState({
    required this.postsInfo,
  });
}

class PostsCubit extends Cubit<PostsState> {
  final PostDataSource postDataSource;

  int page = 1;

  PostsCubit(this.postDataSource) : super(PostsInitialState());

  Future<void> init() async {
    emit(PostsLoadingState());
    page = 1;
    final postsInfo = await postDataSource.getPosts(page: page);
    emit(PostsLoadedState(postsInfo: postsInfo));
  }

  Future<void> nextPage() async {
    final oldState = state;

    if (oldState is! PostsLoadedState) {
      return;
    }

    emit(PostsLoadingState());

    final postsInfo = await postDataSource.getPosts(page: ++page);

    emit(
      PostsLoadedState(
        postsInfo: ListModel<PostPreview>(
          data: [
            ...oldState.postsInfo.data,
            ...postsInfo.data,
          ],
          total: postsInfo.total,
          limit: postsInfo.limit,
          page: postsInfo.page,
        ),
      ),
    );
  }
}
