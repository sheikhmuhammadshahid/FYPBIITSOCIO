import 'package:biit_social/Controllers/SettingController.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/utils/SVConstants.dart';
import 'package:provider/provider.dart';

class SVGroupProfile extends StatelessWidget {
  String url;
  bool isOfficial;
  SVGroupProfile({Key? key, required this.url, required this.isOfficial})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingController>(
      builder: (context, controller, child) {
        return Column(
          children: [
            SizedBox(
              height: 180,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  url == ''
                      ? Image.asset(
                          'images/socialv/backgroundImage.png',
                          width: context.width(),
                          height: 130,
                          fit: BoxFit.cover,
                        ).cornerRadiusWithClipRRectOnly(
                          topLeft: SVAppCommonRadius.toInt(),
                          topRight: SVAppCommonRadius.toInt())
                      : Image.network(
                          profileimageAddress + url,
                          width: context.width(),
                          height: 130,
                          fit: BoxFit.cover,
                        ).cornerRadiusWithClipRRectOnly(
                          topLeft: SVAppCommonRadius.toInt(),
                          topRight: SVAppCommonRadius.toInt()),
                  Positioned(
                    bottom: 0,
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: radius(18)),
                        child: getProfileImage(controller)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getProfileImage(controller) {
    return url == ''
        ? Image.asset('images/socialv/faces/face_5.png',
                height: 88, width: 88, fit: BoxFit.cover)
            .cornerRadiusWithClipRRect(SVAppCommonRadius)
        : isOfficial
            ? Image.asset('images/socialv/faces/face_5.png',
                    height: 88, width: 88, fit: BoxFit.cover)
                .cornerRadiusWithClipRRect(SVAppCommonRadius)
            : Image.network(profileimageAddress + url,
                    height: 88, width: 88, fit: BoxFit.cover)
                .cornerRadiusWithClipRRect(SVAppCommonRadius);
  }
}
