import 'package:biit_social/models/EventModel.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../TimeTable/Calender/SyncfusionCallender.dart';
import '../utils/SVCommon.dart';

class EventsController extends ChangeNotifier {
  List<CalendarEventData> eventsCopy = [];
  List<EventModel> events = [];
  DateTime? selectedDate;
  EventController? eventController = EventController();
  List<Appointment> appointments = <Appointment>[];
  bool gettingEvents = true;
  setState() {
    try {
      notifyListeners();
    } catch (e) {}
  }

  getEvents() async {
    try {
      gettingEvents = true;
      setState();
      var response = await Dio().get('${ip}Event/getEvent');
      if (response.statusCode == 200) {
        eventController = EventController();
        events.clear();
        eventsCopy.clear();
        for (var element in response.data) {
          EventModel ev = EventModel.fromMap(element);
          events.add(ev);
          try {
            eventsCopy.add(CalendarEventData(
                startTime: DateTime.parse(ev.startDate.replaceAll('T', ' ')),
                endTime: DateTime.parse(ev.endDate.replaceAll('T', ' ')),
                title: ev.Name,
                color: getRandomColor(),
                endDate: DateTime.parse(ev.endDate.replaceAll('T', ' ')),
                date: DateTime.parse(ev.startDate.replaceAll('T', ' '))));
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
      var response = await Dio().post('${ip}Event/addEvent',
          data: ev.toJson(), options: Options(headers: headers));
      if (response.statusCode == 200) {
        events.add(EventModel.fromMap(response.data));
        EasyLoading.showToast('Event added successfully!', dismissOnTap: true);
        setState();
      }
    } catch (e) {}
  }

  deleteEvent(int id) async {
    try {
      var response = await Dio().get(
        '${ip}Event/deleteEvent?id=$id',
      );
      if (response.statusCode == 200) {
        events.remove(EventModel.fromMap(response.data));
        EasyLoading.showToast('deleted successfully!', dismissOnTap: true);
        setState();
      }
    } catch (e) {}
  }

  updateEvent(EventModel event) async {
    try {
      var response = await Dio().post('${ip}Event/updateEvent',
          data: event.toJson(), options: Options(headers: headers));
      if (response.statusCode == 200) {
        int e = events.indexWhere((element) => element.id == event.id);
        events[e].Name = event.Name;
        events[e].startDate = event.startDate.replaceAll(' ', 'T');
        events[e].endDate = event.endDate.replaceAll(' ', 'T');

        EasyLoading.showToast('Event updated successfully!',
            dismissOnTap: true);
        setState();
      }
    } catch (e) {}
  }
}
