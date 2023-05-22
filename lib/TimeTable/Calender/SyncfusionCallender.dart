import 'dart:math';

import 'package:biit_social/Controllers/EventsController.dart';
import 'package:biit_social/models/EventModel.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:provider/provider.dart';

import '../../utils/SVCommon.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Event Calendar', style: TextStyle(color: context.iconColor)),
      ),
      body: const EventCalendar(),
    );
  }
}

class EventCalendar extends StatefulWidget {
  const EventCalendar({super.key});

  @override
  _EventCalendarState createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  DateTime? _selectedDate;
  List<Appointment>? _selectedAppointments = [];
  late EventsController eventsController;
  @override
  Widget build(BuildContext context) {
    eventsController = context.read<EventsController>();
    eventsController.getEvents();
    return Consumer<EventsController>(
        builder: (context, value, child) => eventsController.gettingEvents
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  SfCalendar(
                    specialRegions: _getTimeRegion(),
                    view: CalendarView.month,
                    allowAppointmentResize: true,
                    showNavigationArrow: true,
                    allowDragAndDrop: false,
                    dataSource: _getCalendarDataSource(),
                    onTap: (CalendarTapDetails details) {
                      if (details.appointments != null) {
                        if (details.appointments!.isNotEmpty) {
                          setState(() {
                            _selectedDate = details.date!;

                            _selectedAppointments = details.appointments!
                                .cast<Appointment>()
                                .toList();
                          });
                        } else {
                          setState(() {
                            _selectedDate = details.date!;
                            _selectedAppointments!.clear();
                          });
                        }
                      } else {
                        setState(() {
                          _selectedDate = details.date!;
                          _selectedAppointments!.clear();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  if (_selectedDate != null)
                    Text(
                      'Events for ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}:',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  if (_selectedAppointments!.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _selectedAppointments!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: _selectedAppointments![index].color,
                            child: ListTile(
                              title:
                                  Text(_selectedAppointments![index].subject),
                              subtitle: Text(
                                '${_selectedAppointments![index].startTime.hour}:${_selectedAppointments![index].startTime.minute} - ${_selectedAppointments![index].endTime.hour}:${_selectedAppointments![index].endTime.minute}',
                              ),
                              dense: true,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ));
  }

  _getCalendarDataSource() {
    eventsController.appointments.clear();
    for (EventModel element in eventsController.events) {
      eventsController.appointments.add(Appointment(
          startTime: DateTime.parse(element.startDate.replaceAll('T', ' ')),
          endTime: DateTime.parse(element.endDate.replaceAll('T', ' ')),
          color: getRandomColor(),
          subject: element.Name));
    }

    return AppointmentDataSource(eventsController.appointments);
  }

  _getTimeRegion() {
    eventsController.timeRegions.clear();
    for (EventModel element in eventsController.events) {
      eventsController.timeRegions.add(TimeRegion(
        startTime: DateTime.parse(element.startDate.replaceAll('T', ' ')),
        endTime: DateTime.parse(element.endDate.replaceAll('T', ' ')),
        enablePointerInteraction:
            false, // Set this to false to disable interaction with the range
        color: getRandomColor(), // Set the desired color for the range
      ));
    }
    return eventsController.timeRegions;
  }
}

Color getRandomColor() {
  Random random = Random();
  int index = random.nextInt(colorCollection.length);
  return colorCollection[index];
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class Appointment {
  Appointment({
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.color,
  });

  DateTime startTime;
  DateTime endTime;
  String subject;
  Color color;
}
