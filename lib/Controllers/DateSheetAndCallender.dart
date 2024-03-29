import 'package:biit_social/TimeTable/TimeTableModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/DateSheet/DateSheet.dart';
import '../models/DateSheet/DateSheetBy.dart';
import '../utils/SVCommon.dart';

class DateSheetCallender extends ChangeNotifier {
  List<DateSheetBy> dateSheetsBy = [];
  TimeTableModel? timeTable;
  bool isDateLoading = true;
  bool isCallenderLoading = true;
  bool isTimeTableLoading = true;
  List<String> days = [];
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
        days.clear();
        dateSheetsBy.clear();
        // for (var element in response.data['days']) {
        //   days.add(element);
        // }
        try {
          for (var element in response.data[0]['days']) {
            days.add(element);
          }
        } catch (e) {}
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

  setState() {
    try {
      notifyListeners();
    } catch (e) {}
  }

  getAllTimeTable() async {
    try {
      isTimeTableLoading = true;
      setState();
      var response = await Dio().get('${ip}post/getAllTimeTable');
      if (response.statusCode == 200) {
        timeTable = TimeTableModel.fromMap(response.data);
        print(response.data);
      }
    } catch (e) {}
    isTimeTableLoading = false;
    print('done');
    print(timeTable);
    setState();
  }
}
