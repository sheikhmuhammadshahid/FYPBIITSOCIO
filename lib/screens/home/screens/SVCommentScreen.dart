import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/screens/home/components/SVCommentComponent.dart';
import 'package:biit_social/screens/home/components/SVCommentReplyComponent.dart';
import 'package:biit_social/utils/SVColors.dart';
import 'package:provider/provider.dart';
import '../../../../../main.dart';

class SVCommentScreen extends StatefulWidget {
  int postId;
  SVCommentScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<SVCommentScreen> createState() => _SVCommentScreenState();
}

class _SVCommentScreenState extends State<SVCommentScreen> {
  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(context.cardColor);
    });
    init();
  }

  init() async {
    try {
      friendsStoriesController ??= context.read<FriendsStoriesController>();
      friendsStoriesController!.getComments(widget.postId);
    } catch (e) {
      print(e);
    }
  }

  FriendsStoriesController? friendsStoriesController;
  @override
  void dispose() {
    setStatusBarColor(
        appStore.isDarkMode ? appBackgroundColorDark : SVAppLayoutBackground);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    friendsStoriesController ??= context.read<FriendsStoriesController>();
    return Scaffold(
      backgroundColor: context.cardColor,
      appBar: AppBar(
        backgroundColor: context.cardColor,
        iconTheme: IconThemeData(color: context.iconColor),
        title: Text('Comments', style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
        ],
      ),
      body: Column(
        ///alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
              child: Consumer<FriendsStoriesController>(
            builder: (context, value, child) => SizedBox(
                height: value.isCLicked
                    ? context.height() * 0.87
                    : context.height() * 0.79,
                child: !friendsStoriesController!.isStoriesLoading
                    ? friendsStoriesController!.comments.isEmpty
                        ? const Center(
                            child: Text('No comments yet!'),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                friendsStoriesController!.comments.length,
                            itemBuilder: (context, index) => Column(
                              children: [
                                SVCommentComponent(
                                    PostId: widget.postId,
                                    comment: friendsStoriesController!
                                        .comments[index]),
                                for (int i = 0;
                                    i <
                                        friendsStoriesController!
                                            .comments[index].replies!.length;
                                    i++) ...{
                                  SVCommentComponent(
                                      PostId: widget.postId,
                                      comment: friendsStoriesController!
                                          .comments[index].replies![i]),
                                }
                              ],
                            ),
                          )
                    : const Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        ),
                      )),
          )),
          Consumer<FriendsStoriesController>(
            builder: (context, value, child) => value.isCLicked
                ? const SizedBox.shrink()
                : SVCommentReplyComponent(
                    postId: widget.postId,
                    repLiedOn: 0,
                  ),
          )
        ],
      ),
    );
  }
}
