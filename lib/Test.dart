import 'dart:async';

import 'package:biit_social/Controllers/PostController.dart';
import 'package:biit_social/Controllers/SettingController.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'Controllers/NotificatinsCountController.dart';

class ScrollHideNavigationBar extends StatefulWidget {
  const ScrollHideNavigationBar({super.key});

  @override
  _ScrollHideNavigationBarState createState() =>
      _ScrollHideNavigationBarState();
}

class _ScrollHideNavigationBarState extends State<ScrollHideNavigationBar> {
  bool _isScrollingUp = false;
  double _scrollPosition = 0;
  late SettingController settingController;
  @override
  void initState() {
    super.initState();
    settingController = context.read<SettingController>();
    settingController.scrollController = ScrollController();
    notificationCountController = context.read<NotificationCountController>();
    settingController.scrollController.addListener(_scrollListener);
    setTimerForNotifications();
    setState(() {});
  }

  setTimerForNotifications() {
    if (!notificationCountController.timerRunning) {
      notificationCountController.getData(settingController);
      print(DateTime.now().toString());
      Timer.periodic(const Duration(minutes: 2), (timer) {
        try {
          notificationCountController.getData(settingController);
          print(DateTime.now().toString());
        } catch (e) {}
      });
    }
  }

  late NotificationCountController notificationCountController;
  @override
  void dispose() {
    settingController.scrollController.removeListener(_scrollListener);
    settingController.scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (settingController.scrollController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        !_isScrollingUp) {
      setState(() {
        settingController.isAppBarVisible = false;
        _isScrollingUp = true;
      });
    }
    if (settingController.scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        _isScrollingUp) {
      setState(() {
        settingController.isAppBarVisible = true;
        _isScrollingUp = false;
      });
    }

    // Optional: Get the current scroll position
    setState(() {
      _scrollPosition = settingController.scrollController.position.pixels;
    });
  }

  int _currentIndex = 0;
  late PostController postController;

  @override
  Widget build(BuildContext context) {
    postController = context.read<PostController>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: CustomNavigationBar(
        iconSize: 30.0,
        borderRadius: const Radius.circular(10),
        isFloating: true,
        //blurEffect: true,
        selectedColor: context.primaryColor.withOpacity(.8),
        strokeColor: context.primaryColor.withOpacity(.5),
        unSelectedColor: context.primaryColor.withOpacity(.4),
        backgroundColor: context.scaffoldBackgroundColor,
        items: [
          if (loggedInUser!.userType != '3')
            CustomNavigationBarItem(
              badgeCount:
                  context.watch<NotificationCountController>().biitCount,
              showBadge:
                  context.watch<NotificationCountController>().biitCount != 0,
              selectedTitle: const Text('BIIT'),
              icon: const ImageIcon(AssetImage('images/BIIT.png')),
              //  title: const Text("BIIT"),
            ),
          if (loggedInUser!.userType != '4')
            CustomNavigationBarItem(
              badgeCount:
                  context.watch<NotificationCountController>().personalCount,
              showBadge:
                  context.watch<NotificationCountController>().personalCount !=
                      0,
              selectedTitle: const Text('personal'),
              icon: const Icon(Icons.person),
              //  title: const Text("Student"),
            ),
          if (loggedInUser!.userType != '2')
            CustomNavigationBarItem(
              badgeCount:
                  context.watch<NotificationCountController>().teacherCount,
              showBadge:
                  context.watch<NotificationCountController>().teacherCount !=
                      0,
              selectedTitle: const Text('Teacher'),
              //showBadge: true,
              icon: const ImageIcon(
                AssetImage(
                  'images/teacher.png',
                  //color: Colors.black,
                ),
              ),
              // title: const Text("Teacher"),
            ),
          if (loggedInUser!.userType != '1')
            CustomNavigationBarItem(
              showBadge:
                  context.watch<NotificationCountController>().studentCount !=
                      0,
              badgeCount:
                  context.watch<NotificationCountController>().studentCount,
              selectedTitle: const Text('student'),
              icon: const ImageIcon(
                AssetImage(
                  'images/studentLogo.png',
                  //color: Colors.black,
                ),
              ),
              // title: const Text("Societies"),
            ),
          CustomNavigationBarItem(
            showBadge:
                context.watch<NotificationCountController>().societiesCount !=
                    0,
            badgeCount:
                context.watch<NotificationCountController>().societiesCount,
            selectedTitle: const Text('societies'),
            icon: const ImageIcon(
              AssetImage(
                'images/society.png',
                //color: Colors.black,
              ),
            ),
            // title: const Text("Societies"),
          ),
          CustomNavigationBarItem(
            badgeCount:
                context.watch<NotificationCountController>().classPostsCount,
            showBadge:
                context.watch<NotificationCountController>().classPostsCount !=
                    0,
            selectedTitle: const Text('Class'),
            icon: const ImageIcon(
              AssetImage(
                'images/class.png',
                //color: Colors.black,
              ),
            ),
            //title: const Text("Class"),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex || settingController.selectedWall == '7') {
            setState(() {
              _currentIndex = index;
            });
            dothis();
          }
        },
      ),
    ); // : const SizedBox.shrink();
  }

  dothis() {
    if (_currentIndex == 0) {
      settingController.selectedWall = '3';
      notificationCountController.biitCount = 0;
    } else if (_currentIndex == 3) {
      settingController.selectedWall = '6';
      notificationCountController.societiesCount = 0;
    } else if (_currentIndex == 4) {
      settingController.selectedWall = '5';
      notificationCountController.classPostsCount = 0;
    } else if (_currentIndex == 1) {
      if (loggedInUser!.userType == '4') {
        settingController.selectedWall = '2';
        notificationCountController.teacherCount = 0;
      } else if (loggedInUser!.userType != '3') {
        settingController.selectedWall = loggedInUser!.userType!;
        notificationCountController.personalCount = 0;
      } else if (loggedInUser!.userType == '3') {
        settingController.selectedWall = '2';
        notificationCountController.teacherCount = 0;
      }
    } else if (_currentIndex == 2) {
      if (loggedInUser!.userType == '4') {
        settingController.selectedWall = '1';
        notificationCountController.studentCount = 0;
      } else if (loggedInUser!.userType == '1') {
        settingController.selectedWall = '2';
        notificationCountController.teacherCount = 0;
      } else if (loggedInUser!.userType == '2' ||
          loggedInUser!.userType == '3') {
        notificationCountController.studentCount = 0;
        settingController.selectedWall = '1';
      }
    }
    notificationCountController.notifyListeners();
    postController.pageNumber = 0;
    settingController.setState();
    postController.getPosts(settingController);
  }
}
