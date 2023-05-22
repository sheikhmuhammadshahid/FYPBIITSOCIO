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
  getData(SettingController settingController) async {
    try {
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
                          extraInfoSingleItem: e.name,
                          nameSingleItem:
                              e.userType == "1" ? e.aridNo : e.CNIC))
                      .toList()));
        }
      }
      print(items.length);
    } catch (e) {
      print(e);
    }
  }
}
