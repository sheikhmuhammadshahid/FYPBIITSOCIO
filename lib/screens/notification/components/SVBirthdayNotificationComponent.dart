import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/models/SVNotificationModel.dart';
import 'package:biit_social/utils/SVCommon.dart';

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
            Image.asset(element.profileImage.validate(),
                    height: 40, width: 40, fit: BoxFit.cover)
                .cornerRadiusWithClipRRect(8),
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
                    element.ifOfficial.validate()
                        ? Image.asset('images/socialv/icons/ic_TickSquare.png',
                            height: 14, width: 14, fit: BoxFit.cover)
                        : const Offstage(),
                    Text(' and ${element.secondName}',
                        style: secondaryTextStyle(color: svGetBodyColor())),
                  ],
                ),
                6.height,
                Text('have their birthday on ${element.birthDate.validate()}',
                    style: secondaryTextStyle(
                      color: svGetBodyColor(),
                    )),
                6.height,
                Text('${element.dateTime.validate()} ago',
                    style:
                        secondaryTextStyle(color: svGetBodyColor(), size: 12)),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration:
              BoxDecoration(color: context.cardColor, borderRadius: radius(8)),
          child: Image.asset('images/socialv/icons/ic_Cake.png',
              height: 20, width: 20, fit: BoxFit.cover),
        ),
      ],
    ).paddingAll(16);
  }
}
