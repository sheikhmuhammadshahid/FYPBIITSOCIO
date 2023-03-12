import 'package:biit_social/Controllers/PostController.dart';
import 'package:biit_social/screens/home/components/GetItem.dart';
import 'package:biit_social/screens/home/components/TikTokView.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:provider/provider.dart';

class SVPostComponent extends StatefulWidget {
  const SVPostComponent({super.key});

  @override
  State<SVPostComponent> createState() => _SVPostComponentState();
}

class _SVPostComponentState extends State<SVPostComponent> {
  //List<Post> postList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPosts();
  }

  ScrollController? controller;

  getPosts() async {
    try {
      Provider.of<PostController>(context, listen: false).pageNumber = 0;

      Provider.of<PostController>(context, listen: false).getPosts(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // var postController = Provider.of<PostController>(context, listen: false);
    return SafeArea(
      child: Consumer<PostController>(
        builder: (context, postController, child) {
          if (postController.isLoading) {
            return Center(child: getPostsShimmer(context));
          } else {
            return postController.posts.isNotEmpty
                ? LazyLoadScrollView(
                    onEndOfPage: () {
                      postController.getPosts(context);
                    },
                    child: RefreshIndicator(
                      color: context.iconColor,
                      onRefresh: () async {
                        postController.pageNumber = 0;
                        postController.getPosts(context);
                      },
                      child: ListView.builder(
                        controller: controller,
                        itemCount: postController.posts.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return TikTokView(index: index);
                                  },
                                ));
                              },
                              child: getItem(postController, index, context));
                        },
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                      ),
                    ),
                  )
                : RefreshIndicator(
                    color: context.iconColor,
                    onRefresh: () async {
                      postController.pageNumber = 0;
                      postController.getPosts(context);
                    },
                    child: const Center(
                      child: Text('No posts found!'),
                    ),
                  );
          }
        },
      ),
    );
  }
}
