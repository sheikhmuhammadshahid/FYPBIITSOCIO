import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Controllers/PostController.dart';
import '../../../utils/SVCommon.dart';
import '../../../utils/SVConstants.dart';
import '../../../utils/getVideoItem.dart';
import '../screens/SVCommentScreen.dart';

Widget getTikTokItem(
    PostController postController, int index, BuildContext context) {
  return Stack(
    fit: StackFit.expand,
    //crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (postController.posts[index].type == "image" ||
          postController.posts[index].type == "video") ...{
        Center(
          child: SizedBox(
              height: postController.posts[index].type == 'image' ||
                      postController.posts[index].type == 'video'
                  ? MediaQuery.of(context).size.height
                  : null,
              width: context.width(),
              child: postController.posts[index].type == 'image'
                  ? FittedBox(
                      fit: BoxFit.cover,
                      //aspectRatio: 16 / 9,
                      child: sVImageProvider(
                          '$imageAddress${postController.posts[index].text}',
                          250.0,
                          context.width() - 32,
                          GFAvatarShape.square))
                  : AspectRatio(
                      aspectRatio: 3 / 4,
                      child: GetVideoItem(
                          url: imageAddress + postController.posts[index].text),
                    )),
        ),
      } else ...{
        Center(
          child: postController.posts[index].dateTime.validate().isNotEmpty
              ? svRobotoText(
                      color: Colors.white,
                      text: postController.posts[index].description.validate(),
                      textAlign: TextAlign.start)
                  .paddingSymmetric(horizontal: 16)
              : const Offstage(),
        )
      },
      Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  postController.posts[index].userPosted!.profileImage == ""
                      ? Image.asset(
                          'images/socialv/faces/face_5.png'.validate(),
                          height: 56,
                          width: 56,
                          fit: BoxFit.cover,
                        ).cornerRadiusWithClipRRect(SVAppCommonRadius)
                      : Image.network(
                          '${profileimageAddress}3230440894009.jpg',
                          // postController.posts[index]
                          //     .userPosted!.profileImage
                          //     .validate(),
                          height: 56,
                          width: 56,
                          fit: BoxFit.cover,
                        ).cornerRadiusWithClipRRect(SVAppCommonRadius),
                  12.width,
                  Text(postController.posts[index].userPosted!.name.validate(),
                      style: boldTextStyle(color: Colors.white)),
                  4.width,
                  Image.asset('images/socialv/icons/ic_TickSquare.png',
                      height: 14, width: 14, fit: BoxFit.cover),
                ],
              ).paddingSymmetric(horizontal: 16),
              Row(
                children: [
                  Text(
                      '${DateTime.parse(postController.posts[index].dateTime).timeAgo.validate()} ',
                      style: secondaryTextStyle(color: Colors.white, size: 12)),
                  PopupMenuButton(
                    color: Colors.white,
                    itemBuilder: (context) {
                      return [
                        // PopupMenuItem(
                        //     child: TextButton(
                        //         onPressed: () {
                        //           Navigator.pop(context);
                        //         },
                        //         child: Row(
                        //           children: [
                        //             Icon(
                        //               Icons.visibility_off,
                        //               color: svGetBodyColor(),
                        //             ),
                        //             const SizedBox(
                        //               width: 5,
                        //             ),
                        //             Text(
                        //               'Hide',
                        //               style: boldTextStyle(),
                        //             ),
                        //           ],
                        //         ))),
                        if (postController.posts[index].postedBy ==
                            loggedInUser!.CNIC)
                          PopupMenuItem(
                              child: TextButton(
                                  onPressed: () {
                                    postController.deletePost(index);

                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: context.iconColor,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Delete',
                                        style: boldTextStyle(
                                            color: context.iconColor),
                                      ),
                                    ],
                                  ))),
                        PopupMenuItem(
                            child: TextButton(
                                onPressed: () {
                                  postController.posts[index].isPinned!
                                      ? postController.removeFromDiary(index)
                                      : postController.addToDiary(index);
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                        postController.posts[index].isPinned!
                                            ? Icons.bookmark_remove
                                            : Icons.bookmark_add,
                                        color: context
                                            .iconColor //svGetBodyColor(),
                                        ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      !postController.posts[index].isPinned!
                                          ? 'Add to diary'
                                          : "Remove from diary",
                                      style: boldTextStyle(
                                          color: context.iconColor),
                                    ),
                                  ],
                                ))),
                      ];
                    },
                  )
                ],
              ).paddingSymmetric(horizontal: 8),
            ],
          ),
        ),
      ),

      // Image.network(
      //   '$imageAddress${postController.posts[index].text}',
      //   height: 250,
      //   filterQuality: FilterQuality.high,
      //   width: context.width() - 32,
      //   fit: BoxFit.fill,
      // )
      //     .cornerRadiusWithClipRRect(SVAppCommonRadius)
      //     .center(),
      if (postController.posts[index].type != 'text')
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: postController.posts[index].dateTime.validate().isNotEmpty
                ? svRobotoText(
                        color: Colors.white,
                        text:
                            postController.posts[index].description.validate(),
                        textAlign: TextAlign.start)
                    .paddingSymmetric(horizontal: 16)
                : const Offstage(),
          ),
        ),

      Align(
        alignment: Alignment.bottomLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset('images/socialv/icons/ic_Chat.png',
                        height: 22,
                        width: 22,
                        fit: BoxFit.cover,
                        color: Colors.white)
                    .onTap(() {
                  const SVCommentScreen().launch(context);
                },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent),
                IconButton(
                  icon: postController.posts[index].isLiked.validate()
                      ? Image.asset('images/socialv/icons/ic_HeartFilled.png',
                          height: 20,
                          width: 22,
                          color: Colors.red,
                          fit: BoxFit.fill)
                      : Image.asset('images/socialv/icons/ic_Heart.png',
                          height: 22,
                          width: 22,
                          fit: BoxFit.cover,
                          color: Colors.white),
                  onPressed: () {
                    postController.likeOrDislikePost(
                        !postController.posts[index].isLiked!, index);
                  },
                ),
                Image.asset('images/socialv/icons/ic_Send.png',
                        height: 22,
                        width: 22,
                        fit: BoxFit.cover,
                        color: Colors.white)
                    .onTap(() {
                  svShowShareBottomSheet(context);
                },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent),
              ],
            ),
          ],
        ).paddingSymmetric(horizontal: 16),
      ),
    ],
  );
}
