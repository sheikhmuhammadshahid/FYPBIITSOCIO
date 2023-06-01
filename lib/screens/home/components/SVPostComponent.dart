import 'package:biit_social/Controllers/PostController.dart';
import 'package:biit_social/Controllers/SettingController.dart';
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
          postController.getPosts(context.read<SettingController>());
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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
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
                            : postController.getPosts(settingController);
                      },
                      child: RefreshIndicator(
                        color: context.iconColor,
                        onRefresh: () async {
                          postController.fromDiary
                              ? {}
                              : {
                                  postController.pageNumber = 0,
                                  postController.getPosts(settingController)
                                };
                        },
                        child: ListView.builder(
                          controller: settingController.scrollController,
                          itemCount: postController.fromDiary
                              ? postController.pinedPosts.length
                              : postController.posts.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return TikTokView(index: index);
                                    },
                                  ));
                                },
                                child: postController.fromDiary ||
                                        postController
                                            .posts[index].userPosted!.name
                                            .validate()
                                            .toLowerCase()
                                            .contains(postController
                                                .classWallFilter
                                                .toLowerCase())
                                    ? getItem(
                                        postController.fromDiary
                                            ? postController.pinedPosts[index]
                                            : postController.posts[index],
                                        postController,
                                        index,
                                        context)
                                    : const SizedBox.shrink());
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
                                postController.getPosts(settingController)
                              };
                      },
                      child: const Center(
                        child: Text('No posts found!'),
                      ),
                    );
            }
          },
        ),
      ),
    );
  }
}
