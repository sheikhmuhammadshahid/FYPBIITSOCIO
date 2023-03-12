import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/models/SVNotificationModel.dart';
import 'package:biit_social/utils/SVColors.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:provider/provider.dart';

class SVRequestNotificationComponent extends StatelessWidget {
  final SVNotificationModel element;

  SVRequestNotificationComponent({super.key, required this.element});
  late FriendsStoriesController friendsStoriesController;
  @override
  Widget build(BuildContext context) {
    friendsStoriesController = Provider.of<FriendsStoriesController>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        element.profileImage == "" && element.profileImage == null
            ? CircleAvatar(
                radius: 29,
                backgroundImage: AssetImage(
                  "images/socialv/faces/face_5.png".validate(),
                ),
              )
            : sVProfileImageProvider(
                profileimageAddress + element.profileImage!,
                40.0,
                40.0,
              ),
        8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(element.name.validate(), style: boldTextStyle(size: 14)),
                2.width,
                element.ifOfficial.validate()
                    ? Image.asset('images/socialv/icons/ic_TickSquare.png',
                        height: 14, width: 14, fit: BoxFit.cover)
                    : const Offstage(),
                Text('send request to follow you',
                    style: secondaryTextStyle(color: svGetBodyColor())),
              ],
            ),
            6.height,
            Text(element.dateTime.validate(),
                style: secondaryTextStyle(color: svGetBodyColor(), size: 12)),
            16.height,
            if (element.status != 2) ...{
              Row(
                children: [
                  AppButton(
                    shapeBorder:
                        RoundedRectangleBorder(borderRadius: radius(4)),
                    text: 'Confirm',
                    textStyle:
                        secondaryTextStyle(color: Colors.white, size: 14),
                    onTap: () async {
                      await friendsStoriesController.acceptFriendReques(
                          not_id: element.id!,
                          context: context,
                          status: true,
                          to: int.parse(element.body!));
                      dothis();
                    },
                    elevation: 0,
                    color: SVAppColorPrimary,
                    height: 32,
                  ),
                  16.width,
                  AppButton(
                    shapeBorder:
                        RoundedRectangleBorder(borderRadius: radius(4)),
                    text: 'Delete',
                    textStyle:
                        secondaryTextStyle(color: SVAppColorPrimary, size: 14),
                    onTap: () async {
                      await friendsStoriesController.acceptFriendReques(
                          not_id: element.id!,
                          context: context,
                          status: false,
                          to: int.parse(element.body!));
                      dothis();
                    },
                    elevation: 0,
                    color: context.cardColor,
                    height: 32,
                  ),
                ],
              )
            }
          ],
        ),
      ],
    ).paddingAll(16);
  }

  dothis() {
    try {
      if (friendsStoriesController.listToday
          .any((elemnt) => elemnt == element)) {
        friendsStoriesController.listToday
            .firstWhere((elemet) => element.id == elemet.id)
            .status = 2;
      } else if (friendsStoriesController.listMonth
          .any((elemnt) => elemnt == element)) {
        friendsStoriesController.listMonth
            .firstWhere((elemet) => element.id == elemet.id)
            .status = 2;
      } else if (friendsStoriesController.listEarlier
          .any((elemnt) => elemnt == element)) {
        friendsStoriesController.listEarlier
            .firstWhere((elemet) => element.id == elemet.id)
            .status = 2;
      }
    } catch (e) {
      print(e);
    }
    friendsStoriesController.notifyListeners();
  }
}
