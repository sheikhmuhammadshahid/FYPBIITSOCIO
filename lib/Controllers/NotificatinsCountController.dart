import 'package:biit_social/Controllers/SettingController.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../utils/IPHandleClass.dart';

class NotificationCountController extends ChangeNotifier {
  int notificationsCount = 0;
  int classPostsCount = 0;
  int personalCount = 0;
  int teacherCount = 0;
  int societiesCount = 0;
  int biitCount = 0;
  int studentCount = 0;
  bool timerRunning = false;

  getData(SettingController settingController) async {
    try {
      checkConnection(IPHandle.settingController);
      var response = await Dio().get(
          '${IPHandle.ip}User/getNotificatinosData?cnic=${loggedInUser!.CNIC}&fromWall=${settingController.selectedWall}');
      if (response.statusCode == 200) {
        notificationsCount = response.data['notificationsCount'];
        classPostsCount = response.data['classPostsCount'];
        biitCount = response.data['biitCount'];
        societiesCount = response.data['societiesCount'];
        studentCount = response.data['studentCount'];
        teacherCount = response.data['teacherCount'];
        personalCount = response.data['personalCount'];
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
