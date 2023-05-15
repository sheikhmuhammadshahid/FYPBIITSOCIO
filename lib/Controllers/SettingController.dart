import 'package:biit_social/Controllers/PostController.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:biit_social/utils/SVCommon.dart';
import '../models/User/UserModel.dart';

class SettingController extends ChangeNotifier {
  int selectedIndex = 0;
  ScrollController scrollController = ScrollController();
  bool isAppBarVisible = true;
  String selectedIndexText = "BIIT";
  User? userToShow;
  bool isMuted = false;
  bool isPaused = false;
  String selectedWall = "3";
  bool isGettingUser = true;
  changeIndex(index, text, PostController postController,
      SettingController settingController) {
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

    postController.pageNumber = 0;
    settingController.setState();
    postController.getPosts(settingController);
  }

  setState() {
    try {
      notifyListeners();
    } catch (e) {}
  }

  getWidget1(title, icon) {
    if (!items.any((element) => element.title == title)) {
      items.add(Item(
          title: title,
          icon: Icon(
            icon,
            size: 24,
            color: Colors.white,
          )));
    }
  }

  getItems() {
    items.clear();
    getWidget1('BIIT', Icons.admin_panel_settings_sharp);
    getWidget1('Personal', Icons.person);
    getWidget1('Societies', Icons.theater_comedy);
    // getWidget1('Calender', Icons.calendar_month);
    getWidget1('Class', Icons.class_sharp);
    getWidget1('Student', Icons.person);
    getWidget1('Teacher', Icons.person_3);
    getWidget1('Groups', Icons.group);
  }

  List<Item> items = [];

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
    setState();
  }

  changeNavBar(oldIndex, newIndex) {
    final tile = items.removeAt(oldIndex);
    items.insert(newIndex, tile);
    setState();
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
