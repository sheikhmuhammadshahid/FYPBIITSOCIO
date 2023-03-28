import 'package:biit_social/Controllers/PostController.dart';
import 'package:biit_social/Controllers/SettingController.dart';
import 'package:biit_social/screens/home/components/GetItem.dart';
import 'package:biit_social/screens/home/components/TikTokView.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:provider/provider.dart';

import '../../../TimeTable/TimeTableScreen.dart';

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
  late PostController postController;
  getPosts() async {
    try {
      postController = context.read<PostController>();
      if (postController.fromDiary) {
        postController.getPinnedPosts();
      } else {
        if (!postController.isLoading) {
          postController.pageNumber = 0;
          postController.getTimeTable();
          postController.getPosts(context);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var settingController = context.read<SettingController>();
    bool isAdmin = settingController.selectedWall == "3";
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
                      postController.fromDiary
                          ? {}
                          : postController.getPosts(context);
                    },
                    child: RefreshIndicator(
                      color: context.iconColor,
                      onRefresh: () async {
                        postController.fromDiary
                            ? {}
                            : {
                                postController.pageNumber = 0,
                                postController.getPosts(context)
                              };
                      },
                      child: ListView.builder(
                        controller: controller,
                        itemCount: postController.fromDiary
                            ? postController.pinedPosts.length + 1
                            : isAdmin
                                ? postController.posts.length + 1
                                : postController.posts.length,
                        itemBuilder: (context, index) {
                          if ((index == 0 && isAdmin) ||
                              (postController.fromDiary) && index == 0) {
                            return const TimeTableScreen();
                          }
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return TikTokView(index: index - 1);
                                  },
                                ));
                              },
                              child: getItem(
                                  postController.fromDiary
                                      ? postController.pinedPosts[index - 1]
                                      : postController
                                          .posts[isAdmin ? index - 1 : index],
                                  postController,
                                  index - 1,
                                  context));
                        },
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                      ),
                    ),
                  )
                : RefreshIndicator(
                    color: context.iconColor,
                    onRefresh: () async {
                      postController.fromDiary
                          ? {}
                          : {
                              postController.pageNumber = 0,
                              postController.getPosts(context)
                            };
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
