import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/models/SVNotificationModel.dart';
import 'package:biit_social/utils/SVCommon.dart';

import '../../../utils/IPHandleClass.dart';

class SVBirthdayNotificationComponent extends StatelessWidget {
  final SVNotificationModel element;

  const SVBirthdayNotificationComponent({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            element.profileImage == ""
                ? CircleAvatar(
                    radius: 29,
                    backgroundImage: AssetImage(
                      "images/socialv/faces/face_5.png".validate(),
                    ),
                  )
                : sVProfileImageProvider(
                    IPHandle.profileimageAddress + element.profileImage!,
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
                    Text(element.name.validate(),
                        style: boldTextStyle(size: 14)),
                    2.width,
                    // element.ifOfficial.validate()
                    //     ? Image.asset('images/socialv/icons/ic_TickSquare.png',
                    //         height: 14, width: 14, fit: BoxFit.cover)
                    //     : const Offstage(),
                    // Text(' and ${element.secondName}',
                    //     style: secondaryTextStyle(color: svGetBodyColor())),
                  ],
                ),
                6.height,
                Text(element.body.validate(),
                    style: secondaryTextStyle(
                      color: svGetBodyColor(),
                    )),
                6.height,
                Text(element.dateTime.validate(),
                    style:
                        secondaryTextStyle(color: svGetBodyColor(), size: 12)),
              ],
            ),
          ],
        ),
      ],
    ).paddingAll(16);
  }
}
