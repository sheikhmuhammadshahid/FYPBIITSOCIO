import 'package:biit_social/Controllers/PostController.dart';
import 'package:biit_social/screens/fragments/SVProfileFragment.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../models/Post/PostModel.dart';
import '../../../utils/SVCommon.dart';
import '../../../utils/SVConstants.dart';
import '../../../utils/getVideoItem.dart';
import '../screens/SVCommentScreen.dart';

Widget getItem(
    Post post, PostController postController, int index, BuildContext context) {
  // postController.svGetVideoPlayer(
  //     '', '', post.controller);

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
                post.userPosted!.profileImage == ""
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
                                user: post.userPosted!.CNIC.trim() ==
                                        loggedInUser!.CNIC.trim()
                                    ? true
                                    : false,
                                id: post.userPosted!.CNIC,
                              ),
                            ));
                      })
                    : Image.network(
                        profileimageAddress + post.userPosted!.profileImage,
                        // post
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
                                user: post.userPosted!.CNIC.trim() ==
                                        loggedInUser!.CNIC.trim()
                                    ? true
                                    : false,
                                id: post.userPosted!.CNIC,
                              ),
                            ));
                      }),
                12.width,
                Text(post.userPosted!.name.validate(), style: boldTextStyle())
                    .onTap(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SVProfileFragment(
                          user: false,
                          id: post.userPosted!.CNIC,
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
                Text('${DateTime.parse(post.dateTime).timeAgo.validate()} ',
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
                      if (post.postedBy == loggedInUser!.CNIC &&
                          !postController.fromDiary)
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
                                      color:
                                          context.primaryColor.withOpacity(.8),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Delete',
                                      style: boldTextStyle(),
                                    ),
                                  ],
                                ))),
                      PopupMenuItem(
                          child: TextButton(
                              onPressed: () {
                                post.isPinned!
                                    ? postController.removeFromDiary(index)
                                    : postController.addToDiary(index);

                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    post.isPinned!
                                        ? Icons.bookmark_remove
                                        : Icons.bookmark_add,
                                    color: context.primaryColor.withOpacity(.8),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    !post.isPinned!
                                        ? 'Add to diary'
                                        : "Remove from diary",
                                    style:
                                        boldTextStyle(color: context.iconColor),
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
        16.height,
        post.dateTime.validate().isNotEmpty
            ? svRobotoText(
                    text: post.description.validate(),
                    textAlign: TextAlign.start)
                .paddingSymmetric(horizontal: 16)
            : const Offstage(),
        post.description.validate().isNotEmpty ? 16.height : const Offstage(),
        if (post.type == "image" || post.type == "video")
          Center(
            child: SizedBox(
                height: 200,
                width: context.width() - 32,
                child: post.type == 'image'
                    ? sVImageProvider('$imageAddress${post.text}', 250.0,
                        context.width() - 32, GFAvatarShape.square)
                    : AspectRatio(
                        aspectRatio: 3 / 4,
                        child: GetVideoItem(
                            fromNetwork: true, url: imageAddress + post.text),
                      )),
          ),
        // Image.network(
        //   '$imageAddress${post.text}',
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
                  SVCommentScreen(
                    postId: post.id!,
                  ).launch(context);
                },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent),
                IconButton(
                  icon: post.isLiked.validate()
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
                    postController.likeOrDislikePost(!post.isLiked!, index);
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
            Text('${post.CommentsCount.validate()} comments',
                style: secondaryTextStyle(color: svGetBodyColor())),
          ],
        ).paddingSymmetric(horizontal: 16),
        const Divider(indent: 16, endIndent: 16, height: 20),
        //   if (post.likesCount != null && post.likesCount! > 0)
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         SizedBox(
        //           width: 56,
        //           child: Stack(
        //             alignment: Alignment.centerLeft,
        //             children: [
        //               Positioned(
        //                 right: 0,
        //                 child: Container(
        //                   decoration: BoxDecoration(
        //                       border: Border.all(color: Colors.white, width: 2),
        //                       borderRadius: radius(100)),
        //                   child: Image.asset('images/socialv/faces/face_1.png',
        //                           height: 24, width: 24, fit: BoxFit.cover)
        //                       .cornerRadiusWithClipRRect(100),
        //                 ),
        //               ),
        //               Positioned(
        //                 left: 14,
        //                 child: Container(
        //                   decoration: BoxDecoration(
        //                       border: Border.all(color: Colors.white, width: 2),
        //                       borderRadius: radius(100)),
        //                   child: Image.asset('images/socialv/faces/face_2.png',
        //                           height: 24, width: 24, fit: BoxFit.cover)
        //                       .cornerRadiusWithClipRRect(100),
        //                 ),
        //               ),
        //               Positioned(
        //                 child: Container(
        //                   decoration: BoxDecoration(
        //                       border: Border.all(color: Colors.white, width: 2),
        //                       borderRadius: radius(100)),
        //                   child: Image.asset('images/socialv/faces/face_3.png',
        //                           height: 24, width: 24, fit: BoxFit.cover)
        //                       .cornerRadiusWithClipRRect(100),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //         10.width,
        //         RichText(
        //           text: TextSpan(
        //             text: 'Liked By ',
        //             style: secondaryTextStyle(color: svGetBodyColor(), size: 12),
        //             children: <TextSpan>[
        //               TextSpan(
        //                   text: 'Ms.Mountain ', style: boldTextStyle(size: 12)),
        //               TextSpan(
        //                   text: 'And ',
        //                   style: secondaryTextStyle(
        //                       color: svGetBodyColor(), size: 12)),
        //               TextSpan(
        //                   text: '${post.likesCount ?? 0} users',
        //                   style: boldTextStyle(size: 12)),
        //             ],
        //           ),
        //         )
        //       ],
        //     )
      ],
    ),
  );
}
