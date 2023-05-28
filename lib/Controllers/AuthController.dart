import 'dart:convert';

import 'package:biit_social/models/User/UserModel.dart';
import 'package:biit_social/screens/auth/components/SVLoginInComponent.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';
import '../screens/SVDashboardScreen.dart';
import '../screens/auth/screens/SVSignInScreen.dart';
import '../utils/IPHandleClass.dart';
import '../utils/SVCommon.dart';
import 'SettingController.dart';

class AuthController extends ChangeNotifier {
  SharedPreferences? sharedPref;
  bool rememberMe = false;
  List<User> users = [];
  List<User> userToShow = [];
  int pageNo = 0;
  filterUsers(data) {
    try {
      userToShow = users
          .where((element) => element.name!
              .toLowerCase()
              .contains(data.toString().toLowerCase()))
          .toList();
    } catch (e) {
      print(e);
    }
    setState();
  }

  saveLoggedInUser() async {
    try {
      sharedPref = await SharedPreferences.getInstance();
      await sharedPref!.setString('loggedInUser', loggedInUser!.toJson());
      if (rememberMe) {
        sharedPref!.setBool('rememberMe', true);
      } else {
        sharedPref!.setBool('rememberMe', false);
      }
    } catch (e) {
      print(e);
    }
  }

  bool isLoading = true;
  getUsers(SettingController settingController) async {
    try {
      pageNo++;
      if (pageNo == 1) {
        isLoading = true;

        notifyListeners();
      }
      var response = await Dio().get(
          "${IPHandle.ip}User/getAllUsers?pageNo=$pageNo&&cnic=${loggedInUser!.CNIC}&fromWall=${settingController.selectedWall}");
      if (response.statusCode == 200) {
        if (response.data != "No more users") {
          for (var element in response.data) {
            User u = User.fromMap(element["user"]);
            u.isFriend = element["isFriend"];
            u.postsCount = element["postCount"];
            u.countFriends = element["countFriends"];
            users.add(u);
          }
          userToShow = users;
        }
      }
    } catch (e) {
      print(e);
    }
    isLoading = false;
    setState();
  }

  saveStatus(rem) async {
    try {
      rememberMe = rem;
      notifyListeners();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  checkisLoggedIn(BuildContext context) async {
    try {
      sharedPref = await SharedPreferences.getInstance();
      if (sharedPref!.containsKey('rememberMe')) {
        rememberMe = sharedPref!.getBool('rememberMe')!;
        loggedInUser =
            User.fromMap(json.decode(sharedPref!.getString('loggedInUser')!));

        //notifyListeners();
        if (rememberMe) {
          SVLoginInComponent.passwordController.text = loggedInUser!.password;
          SVLoginInComponent.userController.text = loggedInUser!.CNIC;
          // ignore: use_build_context_synchronously

          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SVDashboardScreen(),
              ));
        } else {
          // ignore: use_build_context_synchronously
          const SVSignInScreen().launch(context, isNewTask: true);
        }
      } else {
        // ignore: use_build_context_synchronously
        const SVSignInScreen().launch(context, isNewTask: true);
      }
    } catch (e) {
      print(e);
    }
  }

  checkUserType(context) {
    String type = "";
    if (loggedInUser!.userType == "1") {
      type = "Student";
    } else if (loggedInUser!.userType == "2") {
      type = "Teacher";
    } else if (loggedInUser!.userType == "3") {
      type = "Admin";
    } else if (loggedInUser!.userType == "4") {
      type = "Parent";
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully logged in as $type'),
      //showCloseIcon: true,
      duration: const Duration(seconds: 3),
    ));
  }

  updateToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      loggedInUser!.token = token;

      var response = await Dio().get(
          '${IPHandle.ip}User/updateToken?token=$token&&cnic=${loggedInUser!.CNIC}');
      if (response.statusCode == 200) {}
    } catch (e) {
      print(e);
    }
    saveLoggedInUser();
  }

  login(User u, BuildContext context) async {
    try {
      EasyLoading.show(status: 'Please wait...', dismissOnTap: false);
      //EasyLoading.showInfo('', duration: const Duration(days: 2));
      String url = "${IPHandle.ip}User/LoginUser";
      var response = await Dio()
          .post(url, data: u.toJson(), options: Options(headers: headers));
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        if (response.data["statusCode"] == 200) {
          print(response.data);

          loggedInUser = User.fromMap(response.data["user"]);
          loggedInUser!.countFriends = response.data["countFriends"];
          loggedInUser!.postsCount = response.data["postsCount"];

          // checkUserType(context);
          await updateToken();
          // ignore: use_build_context_synchronously

          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SVDashboardScreen(),
              ));
        } else {
          EasyLoading.showToast(response.data['message']);
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showToast('Something gone wrong!');
      print(e);
    }

    return false;
  }

  updateProfile(FormData data) async {
    try {
      var response = await Dio().post('${IPHandle.ip}Post/updateProfile',
          data: data,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          }));
      if (response.statusCode == 200) {
        if (response.data != "-1") {
          loggedInUser!.profileImage = response.data;
          return true;
        }
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  setState() {
    try {
      notifyListeners();
    } catch (e) {}
  }
}
