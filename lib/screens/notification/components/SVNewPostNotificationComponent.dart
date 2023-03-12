import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/models/SVNotificationModel.dart';
import 'package:biit_social/utils/SVCommon.dart';

class SVNewPostNotificationComponent extends StatelessWidget {
  final SVNotificationModel element;

  const SVNewPostNotificationComponent({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        element.profileImage == ""
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
                Text(' Posted new post',
                    style: secondaryTextStyle(color: svGetBodyColor())),
              ],
            ),
            6.height,
            Text('${element.dateTime.validate()} ',
                style: secondaryTextStyle(color: svGetBodyColor(), size: 12)),
          ],
        ).expand(),
        element.postImage == ""
            ? Image.asset("images/socialv/faces/face_5.png".validate(),
                    height: 48, width: 48, fit: BoxFit.cover)
                .cornerRadiusWithClipRRect(4)
            : sVImageProvider(imageAddress + element.profileImage!, 48, 48,
                GFAvatarShape.square)
      ],
    ).paddingAll(16);
  }
}
