import 'package:biit_social/Controllers/SettingController.dart';
import 'package:biit_social/models/DropDownModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:select2dot1/select2dot1.dart';

import '../models/User/UserModel.dart';
import '../utils/IPHandleClass.dart';
import '../utils/SVCommon.dart';

class DropDownController extends ChangeNotifier {
  List<SingleCategoryModel> items = [];
  List<SingleItemCategoryModel> selectedList = [];
  bool isGetting = true;
  List<String> teachers = [];
  clearItems() {
    try {
      items.clear();
      notifyListeners();
    } catch (e) {}
  }

  saveTAs(FormData data) async {
    try {
      checkConnection(IPHandle.settingController);
      var response = await Dio().post('${IPHandle.ip}User/saveTas',
          data: data,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          }));
      if (response.statusCode == 200) {
        EasyLoading.showToast('Saved Successfully!');
      }
    } catch (e) {}
  }

  getTeachersAndStudents() async {
    try {
      clearItems();
      setIsgetting(true);
      checkConnection(IPHandle.settingController);
      var response =
          await Dio().get('${IPHandle.ip}User/getTeachersAndStudents');
      if (response.statusCode == 200) {
        teachers.clear();
        for (var element in response.data['teachers']) {
          teachers.add(element);
        }
        var element = response.data['students'];
        List<User> users = [];
        for (var element1 in element['users']) {
          users.add(User.fromMap(element1));
        }
        items.add(SingleCategoryModel(
            nameCategory: element['category'],
            singleItemCategoryList: users
                .map((e) => SingleItemCategoryModel(
                    value: e.CNIC,
                    avatarSingleItem: sVProfileImageProvider(
                        IPHandle.profileimageAddress + e.profileImage, 30, 30),
                    extraInfoSingleItem: e.userType == "6" ? 'Society' : e.name,
                    nameSingleItem: e.userType == "1"
                        ? e.aridNo
                        : e.userType == "6"
                            ? e.name ?? ''
                            : e.CNIC))
                .toList()));
      }
    } catch (e) {}
    setIsgetting(false);
  }

  setIsgetting(bool toset) {
    try {
      isGetting = toset;
      notifyListeners();
    } catch (e) {}
  }

  getData(SettingController settingController) async {
    try {
      clearItems();
      setIsgetting(true);
      checkConnection(IPHandle.settingController);
      print(settingController.selectedWall);
      var response = await Dio().get(
          '${IPHandle.ip}user/getDescipline?cnic=${loggedInUser!.CNIC}&fromWall=${settingController.selectedWall}');

      if (response.statusCode == 200) {
        items.clear();
        List<DropDownModel> data = [];
        for (var element in response.data) {
          var v = DropDownModel.fromMap(element);
          data.add(v);
        }

        for (var element in data) {
          items.add(SingleCategoryModel(
              nameCategory: element.category,
              singleItemCategoryList: element.isString
                  ? element.data
                      .map((e) =>
                          SingleItemCategoryModel(value: e, nameSingleItem: e))
                      .toList()
                  : element.users
                      .map((e) => SingleItemCategoryModel(
                          value: e.CNIC,
                          avatarSingleItem: sVProfileImageProvider(
                              IPHandle.profileimageAddress + e.profileImage,
                              30,
                              30),
                          extraInfoSingleItem:
                              e.userType == "6" ? 'Society' : e.name,
                          nameSingleItem: e.userType == "1"
                              ? e.aridNo
                              : e.userType == "6"
                                  ? e.name ?? ''
                                  : e.CNIC))
                      .toList()));
        }
      }
      print(items.length);
    } catch (e) {
      print(e);
    }
    setIsgetting(false);
  }
}
