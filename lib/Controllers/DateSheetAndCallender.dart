import 'package:biit_social/TimeTable/TimeTableModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/DateSheet/DateSheet.dart';
import '../models/DateSheet/DateSheetBy.dart';
import '../utils/IPHandleClass.dart';
import '../utils/SVCommon.dart';

class DateSheetCallender extends ChangeNotifier {
  List<DateSheetBy> dateSheetsBy = [];
  TimeTableModel? timeTable;
  bool isDateLoading = true;
  bool isCallenderLoading = true;
  bool isTimeTableLoading = true;
  List<String> days = [];
  List<DateSheet> datesheet = [];
  List<String> dateSheetTypes = [];
  setstate() {
    try {
      notifyListeners();
    } catch (e) {}
  }

  getDateSheet() async {
    try {
      isDateLoading = true;
      setstate();
      checkConnection(IPHandle.settingController);
      var response = await Dio().get(
          "${IPHandle.ip}User/getDateSheet?cnic=${loggedInUser!.CNIC}&examType=$dateSheettoGet");
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

  String dateSheettoGet = '';
  getExamTypes() async {
    try {
      isTimeTableLoading = true;
      notifyListeners();
      checkConnection(IPHandle.settingController);
      var response = await Dio().get('${IPHandle.ip}User/getDateSheetsTypes');
      if (response.statusCode == 200) {
        dateSheetTypes.clear();
        for (var element in response.data) {
          dateSheetTypes.add(element);
        }
      }
    } catch (e) {}
    isTimeTableLoading = false;
    notifyListeners();
  }

  getAllTimeTable() async {
    try {
      isTimeTableLoading = true;
      setState();
      checkConnection(IPHandle.settingController);
      var response = await Dio().get('${IPHandle.ip}post/getAllTimeTable');
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
