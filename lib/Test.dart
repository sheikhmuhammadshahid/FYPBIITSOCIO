import 'package:biit_social/Controllers/PostController.dart';
import 'package:biit_social/Controllers/SettingController.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

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
    settingController.scrollController.addListener(_scrollListener);
    setState(() {});
  }

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
    return settingController.isAppBarVisible
        ? Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: CustomNavigationBar(
              iconSize: 30.0,
              borderRadius: const Radius.circular(10),
              isFloating: true,
              //blurEffect: true,
              selectedColor: context.iconColor,
              strokeColor: context.iconColor,
              unSelectedColor: const Color(0xffacacac),
              backgroundColor: context.cardColor,
              items: [
                if (loggedInUser!.userType != '3')
                  CustomNavigationBarItem(
                    //   selectedTitle: const Text('BIIT'),
                    icon: const Icon(Icons.admin_panel_settings),
                    //  title: const Text("BIIT"),
                  ),
                if (loggedInUser!.userType != '4')
                  CustomNavigationBarItem(
                    // selectedTitle: const Text('personal'),
                    icon: const Icon(Icons.person),
                    //  title: const Text("Student"),
                  ),
                if (loggedInUser!.userType != '2')
                  CustomNavigationBarItem(
                    badgeCount: 1,
                    //selectedTitle: const Text('Teacher'),
                    showBadge: true,
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
                    //selectedTitle: const Text('student'),
                    icon: const ImageIcon(
                      AssetImage(
                        'images/studentLogo.png',
                        //color: Colors.black,
                      ),
                    ),
                    // title: const Text("Societies"),
                  ),
                CustomNavigationBarItem(
                  // selectedTitle: const Text('societies'),
                  icon: const ImageIcon(
                    AssetImage(
                      'images/society.png',
                      //color: Colors.black,
                    ),
                  ),
                  // title: const Text("Societies"),
                ),
                CustomNavigationBarItem(
                  //  selectedTitle: const Text('Class'),
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
                if (index != _currentIndex) {
                  setState(() {
                    _currentIndex = index;
                  });
                  dothis();
                }
              },
            ),
          )
        : const SizedBox.shrink();
  }

  dothis() {
    if (_currentIndex == 0) {
      settingController.selectedWall = '3';
    } else if (_currentIndex == 3) {
      settingController.selectedWall = '6';
    } else if (_currentIndex == 4) {
      settingController.selectedWall = '5';
    } else if (_currentIndex == 1) {
      if (loggedInUser!.userType == '4') {
        settingController.selectedWall = '2';
      } else {
        settingController.selectedWall = loggedInUser!.userType!;
      }
    } else if (_currentIndex == 2) {
      if (loggedInUser!.userType == '4') {
        settingController.selectedWall = '1';
      } else if (loggedInUser!.userType == '1') {
        settingController.selectedWall = '2';
      } else if (loggedInUser!.userType == '2' ||
          loggedInUser!.userType == '3') {
        settingController.selectedWall = '1';
      }
    }
    postController.pageNumber = 0;
    settingController.setState();
    postController.getPosts(settingController);
  }
}