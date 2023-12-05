import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/posts_cubit.dart';
import 'widgets/post_preview_card.dart';

//class HomePage extends StatefulWidget {
class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout)
          )
        ]
      ),
      body: Center(
        child: Text(
          "You have successfully logged in as " + user.email!,
          style: TextStyle(fontSize: 20),
        )
      ),
    );
  }

  /*@override
  State<HomePage> createState() => _HomePageState();*/
}

/*
class _HomePageState extends State<HomePage> {
  late final ScrollController scrollController;
  late final PostsCubit postsCubit;

  @override
  void initState() {
    scrollController = ScrollController()..addListener(listenScroll);
    postsCubit = PostsCubit(context.read())..init();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<PostsCubit, PostsState>(
        bloc: postsCubit,
        builder: (context, state) {
          return switch (state) {
            PostsLoadedState() => ListView.builder(
                controller: scrollController,
                itemCount: state.postsInfo.data.length,
                prototypeItem: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: PostPreviewCard(
                    postPreview: state.postsInfo.data.first,
                  ),
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: PostPreviewCard(
                      postPreview: state.postsInfo.data[index],
                    ),
                  );
                },
              ),
            _ => const Center(child: CircularProgressIndicator()),
          };
        },
      ),
    );
  }

  Future<void> listenScroll() async {
    final isPageEnd = scrollController.offset + 150 >
        scrollController.position.maxScrollExtent;

    if (isPageEnd) {
      await postsCubit.nextPage();
    }
  }
}*/
