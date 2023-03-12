import 'package:biit_social/Controllers/SettingController.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/utils/SVConstants.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SVProfileHeaderComponent extends StatelessWidget {
  bool? user = false;

  SVProfileHeaderComponent({Key? key, this.user}) : super(key: key);

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
                  if (!controller.isGettingUser) ...{
                    ((user! && loggedInUser!.profileImage == "") ||
                            (!user! &&
                                controller.userToShow!.profileImage == ""))
                        ? Image.asset(
                            'images/socialv/backgroundImage.png',
                            width: context.width(),
                            height: 130,
                            fit: BoxFit.cover,
                          ).cornerRadiusWithClipRRectOnly(
                            topLeft: SVAppCommonRadius.toInt(),
                            topRight: SVAppCommonRadius.toInt())
                        : Image.network(
                            profileimageAddress +
                                (user!
                                    ? loggedInUser!.profileImage
                                    : controller.userToShow!.profileImage),
                            width: context.width(),
                            height: 130,
                            fit: BoxFit.cover,
                          ).cornerRadiusWithClipRRectOnly(
                            topLeft: SVAppCommonRadius.toInt(),
                            topRight: SVAppCommonRadius.toInt()),
                  } else
                    Shimmer.fromColors(
                        //period: const Duration(microseconds: 10),
                        baseColor: Colors.white.withOpacity(0.5),
                        highlightColor: Colors.black.withOpacity(0.1),
                        child: Container(
                          width: context.width(),
                          color: Colors.white,
                        )),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: radius(18)),
                      child: !controller.isGettingUser
                          ? getProfileImage(controller)
                          : Shimmer.fromColors(
                              //period: const Duration(milliseconds: 100),
                              loop: 10,
                              baseColor: Colors.white.withOpacity(0.5),
                              highlightColor: Colors.white,
                              child: Container(
                                width: 88,
                                height: 88,
                                color: Colors.white,
                              )),
                    ),
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
    return ((user! && loggedInUser!.profileImage == "") ||
            (!user! && controller.userToShow!.profileImage == ""))
        ? Image.asset('images/socialv/faces/face_5.png',
                height: 88, width: 88, fit: BoxFit.cover)
            .cornerRadiusWithClipRRect(SVAppCommonRadius)
        : Image.network(
                profileimageAddress +
                    (user!
                        ? loggedInUser!.profileImage
                        : controller.userToShow!.profileImage),
                height: 88,
                width: 88,
                fit: BoxFit.cover)
            .cornerRadiusWithClipRRect(SVAppCommonRadius);
  }
}
