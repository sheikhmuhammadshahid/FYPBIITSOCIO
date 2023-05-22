import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/DateSheet/DateSheet.dart';
import '../models/DateSheet/DateSheetBy.dart';
import '../utils/SVCommon.dart';

class DateSheetCallender extends ChangeNotifier {
  List<DateSheetBy> dateSheetsBy = [];
  bool isDateLoading = true;
  bool isCallenderLoading = true;
  List<DateSheet> datesheet = [];
  setstate() {
    try {
      notifyListeners();
    } catch (e) {}
  }

  getDateSheet() async {
    try {
      isDateLoading = true;
      setstate();
      var response =
          await Dio().get("${ip}User/getDateSheet?cnic=${loggedInUser!.CNIC}");
      if (response.statusCode == 200) {
        dateSheetsBy.clear();
        for (var element in response.data) {
          DateSheetBy d = DateSheetBy.fromMap(element);
          d.dateSheet =
              d.dateSheet.where((element) => element.paper != '').toList();
          dateSheetsBy.add(d);
          // if (d.paper != '') {
          //   datesheet.add(d);
          // }
        }
      }
    } catch (e) {
      print(e);
    }
    isDateLoading = false;
    setstate();
  }
}
