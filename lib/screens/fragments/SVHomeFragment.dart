import 'dart:io';

import 'package:biit_social/Controllers/NotificatinsCountController.dart';
import 'package:biit_social/Controllers/SettingController.dart';
import 'package:biit_social/screens/fragments/SVNotificationFragment.dart';
import 'package:biit_social/screens/fragments/SVProfileFragment.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/screens/home/components/SVHomeDrawerComponent.dart';
import 'package:biit_social/screens/home/components/SVPostComponent.dart';
import 'package:biit_social/utils/SVCommon.dart';
import '../home/components/SVStoryComponent.dart';
import 'SVAddPostFragment.dart';
import 'SVSearchFragment.dart';
import 'package:provider/provider.dart';

class SVHomeFragment extends StatefulWidget {
  const SVHomeFragment({
    super.key,
  });

  @override
  State<SVHomeFragment> createState() => _SVHomeFragmentState();
}

class _SVHomeFragmentState extends State<SVHomeFragment> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  File? image;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(svGetScaffoldColor());
    });
  }

  final GlobalKey _parentKey = GlobalKey();
  late SettingController settingController;
  @override
  Widget build(BuildContext context) {
    settingController = context.read<SettingController>();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: svGetScaffoldColor(),
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
              settingController.selectedWall == loggedInUser!.userType &&
                      context.watch<SettingController>().isAppBarVisible
                  ? context.height() * 0.06
                  : context.height() * 0.01),
          child: Consumer<SettingController>(
            builder: (context, value, child) {
              return Column(
                children: [
                  if (settingController.selectedWall ==
                          loggedInUser!.userType &&
                      settingController.isAppBarVisible) ...{
                    16.height,
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return SVProfileFragment(
                                    id: loggedInUser!.CNIC,
                                    user: true,
                                  );
                                },
                              ));
                            },
                            child: loggedInUser!.profileImage != ""
                                ? CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        profileimageAddress +
                                            loggedInUser!.profileImage))
                                : const CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(
                                        'images/socialv/faces/face_5.png'),
                                  ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2 + 50,
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(
                                      side:
                                          BorderSide(color: context.iconColor)),
                                  backgroundColor:
                                      context.scaffoldBackgroundColor),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SVAddPostFragment(isStatus: false),
                                    ));
                              },
                              child: Text("What's on your mind?",
                                  style: secondaryTextStyle(
                                    size: 16,
                                    color: context.iconColor,
                                  )),
                            ),
                          ),
                          IconButton(
                            icon: Image.asset(
                              'images/socialv/icons/ic_Camera.png',
                              width: 44,
                              height: 40,
                              fit: BoxFit.fill,
                              color: context.iconColor,
                            ),
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SVAddPostFragment(isStatus: false),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                  },
                ],
              );
            },
          ),
        ),
        leading: IconButton(
          icon: Image.asset(
            'images/socialv/icons/ic_More.png',
            width: 18,
            height: 18,
            fit: BoxFit.cover,
            color: context.iconColor,
          ),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text(loggedInUser!.name!, style: boldTextStyle(size: 18)),
        actions: [
          GestureDetector(
            onTap: () {
              const SVSearchFragment().launch(context);
            },
            child: CircleAvatar(
              backgroundColor: context.scaffoldBackgroundColor,

              radius: 10,
              // backgroundImage:
              //     const AssetImage('images/socialv/icons/ic_Search.png'),
              child: Image.asset(
                'images/socialv/icons/ic_Search.png',
                color: context.iconColor,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          //IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SVNotificationFragment();
              }));
            },
            child: CircleAvatar(
              backgroundColor: context.scaffoldBackgroundColor,
              radius: 20,
              child: Badge(
                isLabelVisible: context
                        .watch<NotificationCountController>()
                        .notificationsCount !=
                    0,
                label: Text(context
                    .watch<NotificationCountController>()
                    .notificationsCount
                    .toString()),
                child: Icon(
                  Icons.notifications,
                  color: context.iconColor,
                ),
              ),

              // backgroundImage: AssetImage('images/socialv/icons/ic_User.png'),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Consumer<SettingController>(
            builder: (context, value, child) {
              return (settingController.selectedWall != loggedInUser!.userType)
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return SVProfileFragment(
                              id: loggedInUser!.CNIC,
                              user: true,
                            );
                          },
                        ));
                      },
                      child: loggedInUser!.profileImage != ""
                          ? CircleAvatar(
                              radius: 15,
                              backgroundImage: NetworkImage(
                                  profileimageAddress +
                                      loggedInUser!.profileImage))
                          : const CircleAvatar(
                              radius: 15,
                              backgroundImage:
                                  AssetImage('images/socialv/faces/face_5.png'),
                            ),
                    )
                  : const SizedBox.shrink();
            },
          ),

          const SizedBox(
            width: 10,
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: context.cardColor,
        child: const SVHomeDrawerComponent(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Consumer<SettingController>(
                  builder: (context, value, child) {
                    return Column(
                      children: [
                        if (settingController.selectedWall == "6") ...{
                          5.height,
                          const SVStoryComponent(),
                        },
                      ],
                    );
                  },
                ),
                SizedBox(
                    height: settingController.selectedWall == "6"
                        ? MediaQuery.of(context).size.height * 0.77
                        : settingController.selectedWall ==
                                loggedInUser!.userType
                            ? MediaQuery.of(context).size.height * 0.9
                            : MediaQuery.of(context).size.height * 0.98,
                    child: const SVPostComponent()),
                16.height,
              ],
            ),
          ),
          // const Positioned(bottom: 10, child: SvBottomNavigation())
        ],
      ),
    );
  }
}
