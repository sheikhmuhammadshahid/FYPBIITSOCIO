import 'package:biit_social/Controllers/SettingController.dart';
import 'package:biit_social/models/DropDownModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:select2dot1/select2dot1.dart';

import '../utils/SVCommon.dart';

class DropDownController extends ChangeNotifier {
  List<SingleCategoryModel> items = [];
  List<SingleItemCategoryModel> selectedList = [];
  bool isGetting = true;
  clearItems() {
    try {
      items.clear();
      notifyListeners();
    } catch (e) {}
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
      print(settingController.selectedWall);
      var response = await Dio().get(
          '${ip}user/getDescipline?cnic=${loggedInUser!.CNIC}&fromWall=${settingController.selectedWall}');

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
                              profileimageAddress + e.profileImage, 30, 30),
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
