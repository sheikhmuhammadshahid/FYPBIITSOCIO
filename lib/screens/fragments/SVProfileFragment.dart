import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:biit_social/Controllers/SettingController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/main.dart';
import 'package:biit_social/screens/profile/components/SVProfileHeaderComponent.dart';
import 'package:biit_social/utils/SVCommon.dart';

import '../../utils/SVColors.dart';
import 'package:provider/provider.dart';

import '../../utils/SVConstants.dart';
import '../home/components/SVStoryComponent.dart';
import '../profile/components/SVProfilePostsComponent.dart';

class SVProfileFragment extends StatefulWidget {
  bool? user;
  String id;
  SVProfileFragment({Key? key, this.user, required this.id}) : super(key: key);

  @override
  State<SVProfileFragment> createState() => _SVProfileFragmentState();
}

class _SVProfileFragmentState extends State<SVProfileFragment> {
  @override
  void initState() {
    setStatusBarColor(Colors.transparent);
    super.initState();
    init();
  }

  init() {
    settingController ??= context.read<SettingController>();
    if (!widget.user!) {
      settingController!.getUserProfile(widget.id);
    } else {
      settingController!.isGettingUser = false;
      settingController!.setState();
    }
  }

  SettingController? settingController;
  @override
  Widget build(BuildContext context) {
    var friendController = context.read<FriendsStoriesController>();
    settingController ??= context.read<SettingController>();
    return WillPopScope(
      onWillPop: () async {
        settingController!.isGettingUser = true;
        settingController!.userToShow = null;

        Future.delayed(const Duration(milliseconds: 100)).then((value) {});
        return true;
      },
      child: Observer(
        builder: (_) => Scaffold(
          backgroundColor: svGetScaffoldColor(),
          appBar: AppBar(
            backgroundColor: svGetScaffoldColor(),
            title: Text('Profile', style: boldTextStyle(size: 20)),
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: context.iconColor),
            actions: [
              Switch(
                onChanged: (val) {
                  appStore.toggleDarkMode(value: val);
                },
                value: appStore.isDarkMode,
                activeColor: SVAppColorPrimary,
              ),
              //IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
            ],
          ),
          body: SingleChildScrollView(child: Consumer<SettingController>(
            builder: (context, controller, child) {
              return Column(
                children: [
                  // !controller.isGettingUser ||widget.user!
                  SVProfileHeaderComponent(
                    user: widget.user,
                  ),
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          widget.user!
                              ? loggedInUser!.name!
                              : controller.userToShow != null
                                  ? controller.userToShow!.name!
                                  : '',
                          style: boldTextStyle(size: 20)),
                      4.width,
                      // Image.asset('images/socialv/icons/ic_TickSquare.png',
                      //     height: 14, width: 14, fit: BoxFit.cover),
                    ],
                  ),
                  Text(
                      widget.user!
                          ? loggedInUser!.email!
                          : controller.userToShow != null
                              ? controller.userToShow!.email!
                              : "",
                      style: secondaryTextStyle(color: svGetBodyColor())),
                  24.height,
                  if (controller.userToShow != null &&
                      !widget.user! &&
                      !controller.isGettingUser)
                    if (controller.userToShow!.isFriend!) ...{
                      AppButton(
                        shapeBorder:
                            RoundedRectangleBorder(borderRadius: radius(4)),
                        text: 'Un-Friends',
                        textStyle: boldTextStyle(color: Colors.white),
                        onTap: () async {
                          bool res = await friendController.unFriend(
                              context: context,
                              to: controller.userToShow!.CNIC);
                          if (res) {
                            controller.userToShow!.isFriend = false;
                            controller.notifyListeners();
                          }
                        },
                        elevation: 0,
                        color: SVAppColorPrimary,
                      ),
                    } else
                      AppButton(
                        shapeBorder:
                            RoundedRectangleBorder(borderRadius: radius(4)),
                        text: 'Add-Friend',
                        textStyle: boldTextStyle(color: Colors.white),
                        onTap: () async {
                          friendController.sendFriendReques(
                              controller.userToShow!.CNIC, context);
                        },
                        elevation: 0,
                        color: SVAppColorPrimary,
                      ),
                  24.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('Posts',
                              style: secondaryTextStyle(
                                  color: svGetBodyColor(), size: 12)),
                          4.height,
                          Text(
                              widget.user!
                                  ? loggedInUser!.postsCount.toString()
                                  : controller.userToShow != null
                                      ? controller.userToShow!.postsCount!
                                          .toString()
                                      : "0",
                              style: boldTextStyle(size: 18)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Friends',
                              style: secondaryTextStyle(
                                  color: svGetBodyColor(), size: 12)),
                          4.height,
                          Text(
                              widget.user!
                                  ? loggedInUser!.countFriends.toString()
                                  : controller.userToShow != null
                                      ? controller.userToShow!.countFriends!
                                          .toString()
                                      : "0",
                              style: boldTextStyle(size: 18)),
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     Text('Views',
                      //         style: secondaryTextStyle(
                      //             color: svGetBodyColor(), size: 12)),
                      //     4.height,
                      //     Text('1156m', style: boldTextStyle(size: 18)),
                      //   ],
                      // )
                    ],
                  ),
                  16.height,
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: radius(SVAppCommonRadius)),
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          16.height,
                          Text('Your Stories', style: boldTextStyle(size: 14))
                              .paddingSymmetric(horizontal: 16),
                          const SVStoryComponent(),
                        ],
                      ),
                    ),
                  ),
                  16.height,
                  const SVProfilePostsComponent(),
                  16.height,
                ],
              );
            },
          )),
        ),
      ),
    );
  }
}
