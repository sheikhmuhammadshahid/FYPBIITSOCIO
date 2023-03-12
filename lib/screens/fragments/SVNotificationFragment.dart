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
    init();
  }

  init() {
    friendsController =
        Provider.of<FriendsStoriesController>(context, listen: false);
    friendsController.getNotifications(context);
  }

  int selectedTab = 0;
  //List<String> admin = ['All', 'REQUESTS', 'SOCIETIES'];
  late FriendsStoriesController friendsController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: svGetScaffoldColor(),
        appBar: AppBar(
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
        body: Consumer<FriendsStoriesController>(
          builder: (context, controler, child) {
            return controler.isStoriesLoading
                ? getNotificationShimmer(context)
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TODAY', style: boldTextStyle()).paddingAll(16),
                        const Divider(height: 0, indent: 16, endIndent: 16),
                        Column(
                          children: controler.listToday.map((e) {
                            return getNotificationComponent(
                                type: e.notificationType, element: e);
                          }).toList(),
                        ),
                        Text('THIS MONTH', style: boldTextStyle())
                            .paddingAll(16),
                        const Divider(height: 0, indent: 16, endIndent: 16),
                        Column(
                          children: controler.listMonth.map((e) {
                            return getNotificationComponent(
                                type: e.notificationType, element: e);
                          }).toList(),
                        ),
                        Text('Earlier', style: boldTextStyle()).paddingAll(16),
                        const Divider(height: 0, indent: 16, endIndent: 16),
                        Column(
                          children: controler.listEarlier.map((e) {
                            return getNotificationComponent(
                                type: e.notificationType, element: e);
                          }).toList(),
                        ),
                        16.height,
                      ],
                    ),
                  );
          },
        ));
  }
}
