import 'package:biit_social/screens/fragments/SVProfileFragment.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Controllers/PostController.dart';
import '../../../utils/SVCommon.dart';
import '../../../utils/SVConstants.dart';
import '../../../utils/getVideoItem.dart';
import '../screens/SVCommentScreen.dart';

Widget getItem(PostController postController, int index, BuildContext context) {
  // postController.svGetVideoPlayer(
  //     '', '', postController.posts[index].controller);

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    margin: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
        borderRadius: radius(SVAppCommonRadius), color: context.cardColor),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                      ).cornerRadiusWithClipRRect(SVAppCommonRadius).onTap(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SVProfileFragment(
                                user: postController
                                            .posts[index].userPosted!.CNIC
                                            .trim() ==
                                        loggedInUser!.CNIC.trim()
                                    ? true
                                    : false,
                                id: postController
                                    .posts[index].userPosted!.CNIC,
                              ),
                            ));
                      })
                    : Image.network(
                        '${profileimageAddress}3230440894009.jpg',
                        // postController.posts[index]
                        //     .userPosted!.profileImage
                        //     .validate(),
                        height: 56,
                        width: 56,
                        fit: BoxFit.cover,
                      ).cornerRadiusWithClipRRect(SVAppCommonRadius).onTap(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SVProfileFragment(
                                user: postController
                                            .posts[index].userPosted!.CNIC
                                            .trim() ==
                                        loggedInUser!.CNIC.trim()
                                    ? true
                                    : false,
                                id: postController
                                    .posts[index].userPosted!.CNIC,
                              ),
                            ));
                      }),
                12.width,
                Text(postController.posts[index].userPosted!.name.validate(),
                        style: boldTextStyle())
                    .onTap(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SVProfileFragment(
                          user: false,
                          id: postController.posts[index].userPosted!.CNIC,
                        ),
                      ));
                }),
                4.width,
                // Image.asset('images/socialv/icons/ic_TickSquare.png',
                //     height: 14, width: 14, fit: BoxFit.cover),
              ],
            ).paddingSymmetric(horizontal: 16),
            Row(
              children: [
                Text(
                    '${DateTime.parse(postController.posts[index].dateTime).timeAgo.validate()} ',
                    style:
                        secondaryTextStyle(color: svGetBodyColor(), size: 12)),
                PopupMenuButton(
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
                      //               Icons.pin,
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
                                      color:
                                          context.iconColor //svGetBodyColor(),
                                      ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    !postController.posts[index].isPinned!
                                        ? 'Add to diary'
                                        : "Remove from diary",
                                    style:
                                        boldTextStyle(color: context.iconColor),
                                  ),
                                ],
                              ))),
                      // if (postController.posts[index].postedBy ==
                      //     loggedInUser!.CNIC)
                      //   PopupMenuItem(
                      //       child: TextButton(
                      //           onPressed: () {
                      //             Navigator.pop(context);
                      //           },
                      //           child: Row(
                      //             children: [
                      //               Icon(
                      //                 Icons.edit,
                      //                 color: svGetBodyColor(),
                      //               ),
                      //               Text(
                      //                 'Edit',
                      //                 style: boldTextStyle(),
                      //               ),
                      //             ],
                      //           )))
                    ];
                  },
                )
              ],
            ).paddingSymmetric(horizontal: 8),
          ],
        ),
        16.height,
        postController.posts[index].dateTime.validate().isNotEmpty
            ? svRobotoText(
                    text: postController.posts[index].description.validate(),
                    textAlign: TextAlign.start)
                .paddingSymmetric(horizontal: 16)
            : const Offstage(),
        postController.posts[index].description.validate().isNotEmpty
            ? 16.height
            : const Offstage(),
        if (postController.posts[index].type == "image" ||
            postController.posts[index].type == "video")
          Center(
            child: SizedBox(
                height: 250,
                width: context.width() - 32,
                child: postController.posts[index].type == 'image'
                    ? sVImageProvider(
                        '$imageAddress${postController.posts[index].text}',
                        250.0,
                        context.width() - 32,
                        GFAvatarShape.square)
                    : AspectRatio(
                        aspectRatio: 3 / 4,
                        child: GetVideoItem(
                            fromNetwork: true,
                            url: imageAddress +
                                postController.posts[index].text),
                      )),
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

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'images/socialv/icons/ic_Chat.png',
                  height: 22,
                  width: 22,
                  fit: BoxFit.cover,
                  color: context.iconColor,
                ).onTap(() {
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
                      : Image.asset(
                          'images/socialv/icons/ic_Heart.png',
                          height: 22,
                          width: 22,
                          fit: BoxFit.cover,
                          color: context.iconColor,
                        ),
                  onPressed: () {
                    postController.likeOrDislikePost(
                        !postController.posts[index].isLiked!, index);
                  },
                ),
                Image.asset(
                  'images/socialv/icons/ic_Send.png',
                  height: 22,
                  width: 22,
                  fit: BoxFit.cover,
                  color: context.iconColor,
                ).onTap(() {
                  svShowShareBottomSheet(context);
                },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent),
              ],
            ),
            Text(
                '${postController.posts[index].commentsCount.validate()} comments',
                style: secondaryTextStyle(color: svGetBodyColor())),
          ],
        ).paddingSymmetric(horizontal: 16),
        const Divider(indent: 16, endIndent: 16, height: 20),
        if (postController.posts[index].likesCount != null &&
            postController.posts[index].likesCount! > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 56,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Positioned(
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: radius(100)),
                        child: Image.asset('images/socialv/faces/face_1.png',
                                height: 24, width: 24, fit: BoxFit.cover)
                            .cornerRadiusWithClipRRect(100),
                      ),
                    ),
                    Positioned(
                      left: 14,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: radius(100)),
                        child: Image.asset('images/socialv/faces/face_2.png',
                                height: 24, width: 24, fit: BoxFit.cover)
                            .cornerRadiusWithClipRRect(100),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: radius(100)),
                        child: Image.asset('images/socialv/faces/face_3.png',
                                height: 24, width: 24, fit: BoxFit.cover)
                            .cornerRadiusWithClipRRect(100),
                      ),
                    ),
                  ],
                ),
              ),
              10.width,
              RichText(
                text: TextSpan(
                  text: 'Liked By ',
                  style: secondaryTextStyle(color: svGetBodyColor(), size: 12),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Ms.Mountain ', style: boldTextStyle(size: 12)),
                    TextSpan(
                        text: 'And ',
                        style: secondaryTextStyle(
                            color: svGetBodyColor(), size: 12)),
                    TextSpan(
                        text:
                            '${postController.posts[index].likesCount ?? 0} users',
                        style: boldTextStyle(size: 12)),
                  ],
                ),
              )
            ],
          )
      ],
    ),
  );
}
