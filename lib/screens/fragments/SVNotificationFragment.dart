import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/models/SVNotificationModel.dart';
import 'package:biit_social/screens/notification/components/SVBirthdayNotificationComponent.dart';
import 'package:biit_social/screens/notification/components/SVLikeNotificationComponent.dart';
import 'package:biit_social/screens/notification/components/SVNewPostNotificationComponent.dart';
import 'package:biit_social/screens/notification/components/SVRequestNotificationComponent.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:biit_social/utils/SVConstants.dart';
import 'package:provider/provider.dart';

import '../../Controllers/SettingController.dart';
import '../../utils/IPHandleClass.dart';

class SVNotificationFragment extends StatefulWidget {
  const SVNotificationFragment({super.key});

  @override
  State<SVNotificationFragment> createState() => _SVNotificationFragmentState();
}

class _SVNotificationFragmentState extends State<SVNotificationFragment> {
  // = getNotificationsEarlier();

  Widget getNotificationComponent(
      {String? type, required SVNotificationModel element}) {
    if (type == SVNotificationType.like) {
      return SVLikeNotificationComponent(element: element);
    } else if (type == SVNotificationType.request) {
      return SVRequestNotificationComponent(element: element);
    } else if (type == SVNotificationType.newPost) {
      return SVNewPostNotificationComponent(element: element);
    } else if (type == SVNotificationType.birthday) {
      return SVBirthdayNotificationComponent(element: element);
    } else {
      return const SizedBox();
    }
  }

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(svGetScaffoldColor());
    });
    IPHandle.settingController = context.read<SettingController>();
    //init();
  }

  init() async {
    friendsController ??= context.read<FriendsStoriesController>();
    await friendsController!.getNotifications(context);
  }

  int selectedTab = 0;
  //List<String> admin = ['All', 'REQUESTS', 'SOCIETIES'];
  FriendsStoriesController? friendsController;
  @override
  Widget build(BuildContext context) {
    friendsController ??= context.read<FriendsStoriesController>();
    return Scaffold(
        backgroundColor: svGetScaffoldColor(),
        appBar: AppBar(
          bottom: context.watch<SettingController>().isConnected
              ? null
              : PreferredSize(
                  preferredSize: Size(context.width(), context.width() * 0.01),
                  child: Container(
                    height: context.height() * 0.013,
                    width: context.width(),
                    color: Colors.red,
                    child: FittedBox(
                      child: Center(
                          child: Text(
                        'No internet connection!',
                        style: TextStyle(
                            fontFamily: svFontRoboto, color: Colors.white),
                      )),
                    ),
                  )),
          backgroundColor: svGetScaffoldColor(),
          iconTheme: IconThemeData(color: context.iconColor),
          title: Text('Notification', style: boldTextStyle(size: 20)),
          elevation: 0,
          centerTitle: true,
          // actions: [
          //   IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
          // ],
          // bottom: PreferredSize(
          //   preferredSize: Size(MediaQuery.of(context).size.width, 50),
          //   // child:
          //   child: HorizontalList(
          //     spacing: 0,
          //     padding: const EdgeInsets.all(16),
          //     itemCount: admin.length,
          //     itemBuilder: (context, index) {
          //       return AppButton(
          //         shapeBorder: RoundedRectangleBorder(borderRadius: radius(8)),
          //         text: admin[index], //       : "",
          //         textStyle: boldTextStyle(
          //             color:
          //                 selectedTab == index ? Colors.white : svGetBodyColor(),
          //             size: 14),
          //         onTap: () {
          //           selectedTab = index;
          //           setState(() {});
          //         },
          //         elevation: 0,
          //         color: selectedTab == index
          //             ? SVAppColorPrimary
          //             : svGetScaffoldColor(),
          //       );
          //     },
          //   ),
          // ),
        ),
        body: FutureBuilder(
          future: init(),
          builder: (context, snapshot) => friendsController!
                  .isGettingNotifications
              ? getNotificationShimmer(context)
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TODAY', style: boldTextStyle()).paddingAll(16),
                      const Divider(height: 0, indent: 16, endIndent: 16),
                      Column(
                        children: friendsController!.listToday.map((e) {
                          return getNotificationComponent(
                              type: e.notificationType, element: e);
                        }).toList(),
                      ),
                      Text('THIS MONTH', style: boldTextStyle()).paddingAll(16),
                      const Divider(height: 0, indent: 16, endIndent: 16),
                      Column(
                        children: friendsController!.listMonth.map((e) {
                          return getNotificationComponent(
                              type: e.notificationType, element: e);
                        }).toList(),
                      ),
                      Text('Earlier', style: boldTextStyle()).paddingAll(16),
                      const Divider(height: 0, indent: 16, endIndent: 16),
                      Column(
                        children: friendsController!.listEarlier.map((e) {
                          return getNotificationComponent(
                              type: e.notificationType, element: e);
                        }).toList(),
                      ),
                      16.height,
                    ],
                  ),
                ),
        ));
  }
}
