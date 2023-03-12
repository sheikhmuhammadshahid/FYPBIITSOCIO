import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:biit_social/Controllers/PostController.dart';
import 'package:biit_social/utils/SVCommon.dart';

import '../models/User/UserModel.dart';

class SettingController extends ChangeNotifier {
  int selectedIndex = 0;
  String selectedIndexText = "BIIT";
  User? userToShow;
  bool isMuted = false;
  bool isPaused = false;
  String selectedWall = "3";
  bool isGettingUser = true;
  changeIndex(index, text, context) {
    selectedIndex = index;
    selectedIndexText = items[index].title;
    if (text == 'BIIT') {
      selectedWall = "3";
    } else if (text == "Student") {
      selectedWall = "1";
    } else if (text == "Teacher") {
      selectedWall = "2";
    } else if (text == "Groups") {
      selectedWall = "4";
    } else if (text == "Class") {
      selectedWall = "5";
    } else if (text == "Personal") {
      selectedWall = loggedInUser!.userType!;
    } else if (text == "Societies") {
      selectedWall = "6";
    } else if (text == "Calender") {
      selectedWall = "7";
    }
    PostController p = Provider.of<PostController>(context, listen: false);
    p.posts.clear();
    p.pageNumber = 0;
    p.getPosts(context);
    p.notifyListeners();

    notifyListeners();
  }

  final items = [
    Item(
        title: 'BIIT',
        icon: const Icon(
          Icons.admin_panel_settings_sharp,
          size: 24,
          color: Colors.white,
        )),
    Item(
        title: 'Personal',
        icon: const Icon(
          Icons.personal_injury,
          size: 24,
          color: Colors.white,
        )),
    Item(
        title: 'Societies',
        icon: const Icon(
          Icons.theater_comedy,
          size: 24,
          color: Colors.white,
        )),
    Item(
        title: 'Calender',
        icon: const Icon(
          Icons.calendar_month,
          size: 24,
          color: Colors.white,
        )),
    Item(
        title: 'Class',
        icon: const Icon(
          Icons.class_sharp,
          size: 24,
          color: Colors.white,
        )),
    Item(
        title: 'Student',
        icon: const Icon(
          Icons.person,
          size: 24,
          color: Colors.white,
        )),
    Item(
        title: 'Teacher',
        icon: const Icon(
          Icons.theater_comedy,
          size: 24,
          color: Colors.white,
        )),
    Item(
        title: 'Groups',
        icon: const Icon(
          Icons.group,
          size: 24,
          color: Colors.white,
        )),
  ];

  var navItems = [];
  getWidget(context, index) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          items[index].icon,
          const SizedBox(
            width: 4,
          ),
          Text(
            items[index].title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white
                //color: context.iconColor,
                ),
          ),
        ]);
  }

  getUserProfile(frined) async {
    try {
      var response = await Dio().get(
          "${ip}User/getUser?friendof=${loggedInUser!.CNIC}&&friend=$frined");
      if (response.statusCode == 200) {
        userToShow = User.fromMap(response.data["user"]);
        userToShow!.countFriends = response.data["countFriends"];
        userToShow!.postsCount = response.data["postsCount"];
        userToShow!.isFriend = response.data["isFriend"];
      }
    } catch (e) {}
    isGettingUser = false;
    notifyListeners();
  }

  changeNavBar(oldIndex, newIndex) {
    final tile = items.removeAt(oldIndex);
    items.insert(newIndex, tile);
    notifyListeners();
  }
}

class Item {
  String title;
  Widget icon;
  Item({
    required this.title,
    required this.icon,
  });

  Item copyWith({
    String? title,
    Widget? icon,
  }) {
    return Item(
      title: title ?? this.title,
      icon: icon ?? this.icon,
    );
  }
}
