import 'package:biit_social/models/EventModel.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../TimeTable/Calender/SyncfusionCallender.dart' as syn;
import '../utils/IPHandleClass.dart';
import '../utils/SVCommon.dart';

class EventsController extends ChangeNotifier {
  List<CalendarEventData> eventsCopy = [];
  List<EventModel> events = [];
  Color colorSelected = Colors.black;
  DateTime? selectedDate;
  EventController? eventController = EventController();
  List<syn.Appointment> appointments = <syn.Appointment>[];
  bool gettingEvents = true;
  List<TimeRegion> timeRegions = [];
  setState() {
    try {
      notifyListeners();
    } catch (e) {}
  }

  getEvents() async {
    try {
      gettingEvents = true;
      setState();
      checkConnection(IPHandle.settingController);
      var response = await Dio().get('${IPHandle.ip}Event/getEvent');
      print(response.data);
      if (response.statusCode == 200) {
        eventController = EventController();
        events.clear();
        eventsCopy.clear();
        for (var element in response.data) {
          EventModel ev = EventModel.fromMap(element);
          events.add(ev);

          try {
            DateTime dt1 = DateTime.parse(ev.startDate.replaceAll('T', ' '));
            DateTime dt2 = DateTime.parse(ev.endDate.replaceAll('T', ' '));
            print(dt1.toString());
            print(dt1.subtract(const Duration(days: 2)).toString());
            eventsCopy.add(CalendarEventData(
                description: ev.id.toString(),
                startTime: dt1,
                endTime: dt2,
                title: ev.Name,
                color: colorCollection[ev.colorId],
                endDate: dt2,
                date: dt2.dateYMD == dt1.dateYMD
                    ? dt1
                    : dt1.subtract(const Duration(days: 1))));
          } catch (e) {}
        }
        eventController!.addAll(eventsCopy);
      }
    } catch (e) {
      print(e);
    }

    gettingEvents = false;
    eventsCopy.clear();
    setState();
    print(events.length);
  }

  addEvent(EventModel ev) async {
    try {
      checkConnection(IPHandle.settingController);
      var response = await Dio().post('${IPHandle.ip}Event/addEvent',
          data: ev.toJson(), options: Options(headers: headers));
      if (response.statusCode == 200) {
        EventModel ev = EventModel.fromMap(response.data);
        events.add(ev);
        DateTime dt1 = DateTime.parse(ev.startDate.replaceAll('T', ' '));
        DateTime dt2 = DateTime.parse(ev.endDate.replaceAll('T', ' '));

        var re = CalendarEventData(
            description: ev.id.toString(),
            startTime: dt1,
            endTime: dt2,
            title: ev.Name,
            color: colorCollection[ev.colorId],
            endDate: dt2,
            date: dt2.dateYMD == dt1.dateYMD
                ? dt1
                : dt1.subtract(const Duration(days: 1)));
        eventController!.add(re);
        if (selectedDate.toString().splitBefore(' ') ==
            dt1.toString().splitBefore(' ')) {
          eventsCopy.add(re);
        }
        EasyLoading.showToast('Event added successfully!', dismissOnTap: true);
        setState();
      }
    } catch (e) {}
  }

  deleteEvent(int id) async {
    try {
      var response = await Dio().get(
        '${IPHandle.ip}Event/deleteEvent?id=$id',
      );
      checkConnection(IPHandle.settingController);
      if (response.statusCode == 200) {
        EventModel ev = EventModel.fromMap(response.data);
        events.remove(ev);
        eventsCopy
            .removeWhere((element) => element.description == ev.id.toString());
        eventController!
            .removeWhere((element) => element.description == ev.id.toString());
        EasyLoading.showToast('deleted successfully!', dismissOnTap: true);
        setState();
      }
    } catch (e) {}
  }

  updateEvent(EventModel event) async {
    try {
      checkConnection(IPHandle.settingController);
      var response = await Dio().post('${IPHandle.ip}Event/updateEvent',
          data: event.toJson(), options: Options(headers: headers));
      if (response.statusCode == 200) {
        int e = events.indexWhere((element) => element.id == event.id);
        events[e].Name = event.Name;
        events[e].startDate = event.startDate.replaceAll(' ', 'T');
        events[e].endDate = event.endDate.replaceAll(' ', 'T');
        eventController!.removeWhere(
            (element) => element.description == events[e].id.toString());
        bool isDeleted = eventsCopy
            .any((element) => element.description == events[e].id.toString());
        eventsCopy.removeWhere(
            (element) => element.description == events[e].id.toString());

        EventModel ev = events[e];
        DateTime dt1 = DateTime.parse(ev.startDate.replaceAll('T', ' '));
        DateTime dt2 = DateTime.parse(ev.endDate.replaceAll('T', ' '));
        if (isDeleted) {
          eventsCopy.add(CalendarEventData(
              description: ev.id.toString(),
              startTime: dt1,
              endTime: dt2,
              title: ev.Name,
              color: colorCollection[ev.colorId],
              endDate: dt2,
              date: dt2.dateYMD == dt1.dateYMD
                  ? dt1
                  : dt1.subtract(const Duration(days: 1))));
        }
        eventController!.add(CalendarEventData(
            description: ev.id.toString(),
            startTime: dt1,
            endTime: dt2,
            title: ev.Name,
            color: colorCollection[ev.colorId],
            endDate: dt2,
            date: dt2.dateYMD == dt1.dateYMD
                ? dt1
                : dt1.subtract(const Duration(days: 1))));
        EasyLoading.showToast('Event updated successfully!',
            dismissOnTap: true);
        setState();
      }
    } catch (e) {}
  }
}
