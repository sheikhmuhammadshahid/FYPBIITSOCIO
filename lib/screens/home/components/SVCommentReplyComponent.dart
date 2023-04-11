import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:biit_social/models/SVCommentModel.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/utils/SVColors.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:provider/provider.dart';

class SVCommentReplyComponent extends StatelessWidget {
  int postId;
  int repLiedOn;
  SVCommentReplyComponent(
      {Key? key, required this.postId, required this.repLiedOn})
      : super(key: key);
  TextEditingController commentControlelr = TextEditingController();
  late FriendsStoriesController friendsStoriesController;
  @override
  Widget build(BuildContext context) {
    friendsStoriesController = context.read<FriendsStoriesController>();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: svGetScaffoldColor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Divider(indent: 16, endIndent: 16, height: 20),
          FittedBox(
            child: Row(
              children: [
                16.width,
                loggedInUser!.profileImage == ''
                    ? Image.asset('images/socialv/faces/face_5.png',
                            height: 48, width: 48, fit: BoxFit.cover)
                        .cornerRadiusWithClipRRect(8)
                    : Image.network(
                            profileimageAddress + loggedInUser!.profileImage,
                            height: 48,
                            width: 48,
                            fit: BoxFit.cover)
                        .cornerRadiusWithClipRRect(8),
                10.width,
                SizedBox(
                  width: context.width() * 0.6,
                  child: AppTextField(
                    controller: commentControlelr,
                    textFieldType: TextFieldType.OTHER,
                    decoration: InputDecoration(
                      hintText: 'Write A Comment',
                      hintStyle: secondaryTextStyle(color: svGetBodyColor()),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      var v = SVCommentModel(
                          comment: commentControlelr.text,
                          id: 0,
                          isCommentReply: !(repLiedOn == 0),
                          like: false,
                          likeCount: 0,
                          name: loggedInUser!.name,
                          profileImage: loggedInUser!.profileImage,
                          replies: [],
                          time: DateTime.now().toString());
                      if (repLiedOn != 0) {
                        var res = friendsStoriesController.comments
                            .where((element) => element.id == repLiedOn)
                            .toList();
                        if (res.isNotEmpty) {
                          res[0].replies!.add(v);
                        }
                      } else {
                        friendsStoriesController.comments.add(v);
                      }

                      friendsStoriesController.addComment(postId, repLiedOn);
                    },
                    child: Text('Reply',
                        style: secondaryTextStyle(color: SVAppColorPrimary)))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
