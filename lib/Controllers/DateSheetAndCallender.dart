import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/DateSheet.dart';
import '../utils/SVCommon.dart';

class DateSheetCallender extends ChangeNotifier {
  bool isDateLoading = true;
  bool isCallenderLoading = true;
  List<DateSheet> datesheet = [];
  getDateSheet() async {
    try {
      isDateLoading = true;
      notifyListeners();
      var response = await Dio().get("${ip}User/getDateSheet?section=BCS-8c");
      if (response.statusCode == 200) {
        datesheet.clear();
        for (var element in response.data) {
          DateSheet d = DateSheet.fromMap(element);
          if (d.paper != '') {
            datesheet.add(d);
          }
        }
      }
    } catch (e) {}
    isDateLoading = false;
    notifyListeners();
  }
}
