import 'package:biit_social/screens/auth/screens/SVSignInScreen.dart';
import 'package:biit_social/screens/profile/screens/FriendsListScreen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/models/SVCommonModels.dart';
import 'package:biit_social/screens/home/screens/SVForumScreen.dart';
import 'package:biit_social/utils/SVColors.dart';
import 'package:biit_social/utils/SVCommon.dart';

import '../../Teacher/givePermission.dart';
import '../../auth/components/SVLoginInComponent.dart';
import '../../fragments/SVProfileFragment.dart';
import '../../profile/screens/GroupsListScreen.dart';

class SVHomeDrawerComponent extends StatefulWidget {
  const SVHomeDrawerComponent({super.key});

  @override
  State<SVHomeDrawerComponent> createState() => _SVHomeDrawerComponentState();
}

class _SVHomeDrawerComponentState extends State<SVHomeDrawerComponent> {
  List<SVDrawerModel> options = getDrawerOptions();

  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          50.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  loggedInUser!.profileImage != ""
                      ? Image.network(
                              profileimageAddress + loggedInUser!.profileImage,
                              height: 62,
                              width: 62,
                              fit: BoxFit.cover)
                          .cornerRadiusWithClipRRect(8)
                      : Image.asset('images/socialv/faces/face_5.png',
                              height: 62, width: 62, fit: BoxFit.cover)
                          .cornerRadiusWithClipRRect(8),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(loggedInUser!.name!, style: boldTextStyle(size: 18)),
                      8.height,
                      Text(loggedInUser!.email!,
                          style: secondaryTextStyle(color: svGetBodyColor())),
                    ],
                  ),
                ],
              ),
              // IconButton(
              //   icon: Image.asset('images/socialv/icons/ic_CloseSquare.png',
              //       height: 16,
              //       width: 16,
              //       fit: BoxFit.cover,
              //       color: context.iconColor),
              //   onPressed: () {
              //     finish(context);
              //   },
              // ),
            ],
          ).paddingOnly(left: 16, right: 8, bottom: 20, top: 20),
          20.height,
          SingleChildScrollView(
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: options.map((e) {
                int index = options.indexOf(e);
                return SettingItemWidget(
                  decoration: BoxDecoration(
                      color: selectedIndex == index
                          ? SVAppColorPrimary.withAlpha(30)
                          : context.cardColor),
                  title: e.title.validate(),
                  titleTextStyle: boldTextStyle(size: 14),
                  leading: Image.asset(e.image.validate(),
                      height: 22,
                      width: 22,
                      fit: BoxFit.cover,
                      color: context.iconColor),
                  onTap: () {
                    selectedIndex = index;
                    setState(() {});

                    if (selectedIndex == options.length - 1) {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return const SVSignInScreen();
                        },
                      ));
                    } else if (selectedIndex == 4) {
                      finish(context);
                      const SVDiarScreen().launch(context);
                    } else if (selectedIndex == 1) {
                      finish(context);
                      FriendsListScreen(
                        toShow: 'friends',
                      ).launch(context);
                    } else if (selectedIndex == 0) {
                      finish(context);
                      SVProfileFragment(
                        id: loggedInUser!.CNIC,
                        user: true,
                      ).launch(context);
                    } else if (selectedIndex == 2) {
                      finish(context);
                      GroupsListScreen(
                        toShow: 'Groups',
                      ).launch(context);
                    }
                  },
                );
              }).toList(),
            ),
          ),
          if (SVLoginInComponent.loggedIn == 2)
            SettingItemWidget(
              title: 'Give Permissions',
              titleTextStyle: boldTextStyle(size: 14),
              leading: Icon(
                Icons.lock,
                color: context.iconColor,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SVGivePermission(),
                    ));
              },
            ),
          const Divider(indent: 16, endIndent: 16),
          20.height,
        ],
      ),
    );
  }
}
