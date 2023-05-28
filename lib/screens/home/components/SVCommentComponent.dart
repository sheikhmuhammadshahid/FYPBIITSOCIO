import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/models/SVCommentModel.dart';
import 'package:biit_social/utils/SVCommon.dart';

import '../../../utils/IPHandleClass.dart';
import 'SVCommentReplyComponent.dart';

class SVCommentComponent extends StatefulWidget {
  int PostId;
  final SVCommentModel comment;

  SVCommentComponent({super.key, required this.comment, required this.PostId});

  @override
  State<SVCommentComponent> createState() => _SVCommentComponentState();
}

class _SVCommentComponentState extends State<SVCommentComponent> {
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                widget.comment.profileImage == ''
                    ? Image.asset('images/socialv/faces/face_5.png'.validate(),
                            height: 48, width: 48, fit: BoxFit.cover)
                        .cornerRadiusWithClipRRect(8)
                    : Image.network(
                            IPHandle.profileimageAddress +
                                widget.comment.profileImage!,
                            height: 48,
                            width: 48,
                            fit: BoxFit.cover)
                        .cornerRadiusWithClipRRect(8),
                16.width,
                Text(widget.comment.name.validate(),
                    style: boldTextStyle(size: 14)),
                4.width,
                // Image.asset('images/socialv/icons/ic_TickSquare.png',
                //     height: 14, width: 14, fit: BoxFit.cover),
              ],
            ),
            Row(
              children: [
                Image.asset(
                  'images/socialv/icons/ic_TimeSquare.png',
                  height: 14,
                  width: 14,
                  fit: BoxFit.cover,
                  color: context.iconColor,
                ),
                4.width,
                Text(DateTime.parse(widget.comment.time.validate()).timeAgo,
                    style:
                        secondaryTextStyle(color: svGetBodyColor(), size: 12)),
              ],
            )
          ],
        ),
        16.height,
        Text(widget.comment.comment.validate(),
            style: secondaryTextStyle(color: svGetBodyColor())),
        16.height,
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: radius(4), color: svGetScaffoldColor()),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.comment.like.validate()
                      ? Image.asset('images/socialv/icons/ic_HeartFilled.png',
                          height: 14, width: 14, fit: BoxFit.fill)
                      : Image.asset(
                          'images/socialv/icons/ic_Heart.png',
                          height: 14,
                          width: 14,
                          fit: BoxFit.cover,
                          color: svGetBodyColor(),
                        ),
                  2.width,
                  Text(widget.comment.likeCount.toString(),
                      style: secondaryTextStyle(size: 12)),
                ],
              ),
            ).onTap(() {
              widget.comment.like = !widget.comment.like.validate();
              setState(() {});
            }, borderRadius: radius(4)),
            16.width,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: radius(4),
                  color: isClicked ? context.iconColor : svGetScaffoldColor()),
              child: Text('Reply',
                  style: secondaryTextStyle(
                      size: 12, color: isClicked ? Colors.white : null)),
            ).onTap(() {
              friendsStoriesController!.isCLicked = !isClicked;
              friendsStoriesController!.setState();
              setState(() {
                isClicked = !isClicked;
              });
            })
          ],
        ),
        if (isClicked) ...{
          10.height,
          SizedBox(
            height: context.width() * 0.3,
            child: SVCommentReplyComponent(
              postId: widget.PostId,
              repLiedOn: widget.comment.id,
            ),
          )
        }
      ],
    ).paddingOnly(
        top: 16,
        left: widget.comment.isCommentReply.validate() ? 70 : 16,
        right: 16,
        bottom: 16);
  }
}
