import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/utils/SVCommon.dart';

import '../../../models/User/UserModel.dart';
import '../../../utils/IPHandleClass.dart';

class SVSearchCardComponent extends StatelessWidget {
  final User element;

  const SVSearchCardComponent({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            element.profileImage == ""
                ? Image.asset(
                    'images/socialv/faces/face_2.png',
                    height: 56,
                    width: 56,
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(8)
                : Image.network(
                        IPHandle.profileimageAddress +
                            element.profileImage.validate(),
                        height: 56,
                        width: 56,
                        fit: BoxFit.cover)
                    .cornerRadiusWithClipRRect(8),
            20.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(element.name.validate(), style: boldTextStyle()),
                    6.width,
                    // element.isOfficialAccount.validate()
                    //     ? Image.asset('images/socialv/icons/ic_TickSquare.png',
                    //         height: 14, width: 14, fit: BoxFit.cover)
                    //     : const Offstage(),
                  ],
                ),
                6.height,
                Text(
                    element.userType == "1"
                        ? element.section.validate()
                        : element.userType == "2"
                            ? "Teacher"
                            : element.userType == "3"
                                ? "Admin"
                                : "",
                    style: secondaryTextStyle(color: svGetBodyColor())),
              ],
            ),
          ],
        ),
        Image.asset(
          'images/socialv/icons/ic_CloseSquare.png',
          height: 20,
          width: 20,
          fit: BoxFit.cover,
          color: context.iconColor,
        ),
      ],
    );
  }
}
