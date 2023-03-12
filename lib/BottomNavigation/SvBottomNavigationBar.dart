import 'dart:ui';

import 'package:biit_social/utils/SVCommon.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../Controllers/SettingController.dart';
import 'package:provider/provider.dart';

class SvBottomNavigation extends StatefulWidget {
  const SvBottomNavigation({super.key});

  @override
  State<SvBottomNavigation> createState() => _SvBottomNavigationState();
}

class _SvBottomNavigationState extends State<SvBottomNavigation> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  late SettingController settingController;
  bool done = true;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    settingController = Provider.of<SettingController>(context);

    // settingController.getWidget(context);

    return Consumer<SettingController>(
      builder: (context, value, child) {
        try {
          if (loggedInUser!.userType == "1") {
            var v =
                value.items.firstWhere((element) => element.title == 'Student');
            settingController.items.remove(v);
          } else if (loggedInUser!.userType == "2") {
            var v =
                value.items.firstWhere((element) => element.title == 'Teacher');
            settingController.items.remove(v);
          } else if (loggedInUser!.userType == "3") {
            var v =
                value.items.firstWhere((element) => element.title == 'BIIT');
            settingController.items.remove(v);
          } else if (loggedInUser!.userType == "4") {
            var v = value.items
                .where((element) =>
                    element.title == 'Groups' || element.title == 'Class')
                .toList();
            for (var element in v) {
              settingController.items.remove(element);
            }
          }
        } catch (e) {}
        return Container(
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: ReorderableListView(
              proxyDecorator: (child, index, animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    final double animValue =
                        Curves.easeInOut.transform(animation.value);
                    final double elevation = lerpDouble(0, 6, animValue)!;
                    return Material(
                      elevation: elevation,
                      color: Colors.transparent,
                      shadowColor: Colors.black.withOpacity(0.5),
                      child: child,
                    );
                  },
                  child: child,
                );
              },
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              onReorder: (oldIndex, newIndex) {
                if (oldIndex < newIndex) newIndex--;
                settingController.changeNavBar(oldIndex, newIndex);
              },
              children: [
                for (int i = 0; i < settingController.items.length; i++)
                  GestureDetector(
                    key: ValueKey(i),
                    onTap: () {
                      settingController.changeIndex(
                          i, settingController.items[i].title, context);
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: Chip(
                            visualDensity: VisualDensity.standard,
                            backgroundColor:
                                settingController.selectedIndexText ==
                                        settingController.items[i].title
                                    ? context.primaryColor.withOpacity(0.9)
                                    : context.iconColor.withOpacity(0.5),
                            label: settingController.getWidget(context, i))),
                  )
              ]),
        );
      },
    );
  }
}

class BottomNavigationItem {
  String? lable;
  Widget? icon;
  Widget? activeIcon;

  BottomNavigationItem({this.lable, this.icon, this.activeIcon});
}
