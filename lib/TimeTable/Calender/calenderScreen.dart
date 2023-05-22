import 'package:biit_social/Controllers/EventsController.dart';
import 'package:biit_social/utils/SVConstants.dart';
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  getDayView() {
    return DayView(
      controller: eventsController!.eventController,
      eventTileBuilder: (date, events, boundry, start, end) {
        // Return your widget to display as event tile.
        return Container(
          height: 100,
          color: Colors.red,
        );
      },

      fullDayEventBuilder: (events, date) {
        // Return your widget to display full day event view.
        return Container(
          color: Colors.red,
        );
      },
      showVerticalLine: true, // To display live time line in day view.
      showLiveTimeLineInAllDays:
          true, // To display live time line in all pages in day view.
      minDay: DateTime(DateTime.now().year),
      maxDay: DateTime(DateTime.now().year + 1),
      initialDay: DateTime.now(),
      heightPerMinute: 1, // height occupied by 1 minute time span.
      eventArranger:
          const SideEventArranger(), // To define how simultaneous events will be arranged.
      onEventTap: (events, date) {
        if (events.isNotEmpty) {
          eventsController!.eventsCopy.clear();
          eventsController!.eventsCopy.addAll(events);
          eventsController!.setState();
        }
      },
      onDateLongPress: (date) => print(date),
    );
  }

  getMonthVIew() {
    return MonthView(
      controller: eventsController!.eventController,

      pageTransitionCurve: Curves.easeInCirc,
      cellAspectRatio: 12 / 9,
      // to provide custom UI for month cells.
      cellBuilder: (date, events, isToday, isInMonth) {
        bool hasEvents = events.isNotEmpty;

        return Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  '${date.day}', // Display the day of the month
                  style: TextStyle(
                    color: context.iconColor,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (hasEvents) ...{
                  for (int i = 0; i < events.length; i++) ...{
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      height: 12,
                      color: events[i].color,
                    )
                  }
                }
              ],
            ),
          ),
        );
      },
      minMonth: DateTime(DateTime.now().year),
      maxMonth: DateTime(DateTime.now().year + 1),
      initialMonth: DateTime.now(),
      // /cellAspectRatio: 1,
      onPageChange: (date, pageIndex) => print("$date, $pageIndex"),
      onCellTap: (events, date) {
        // Implement callback when user taps on a cell.
        eventsController!.selectedDate = date;
        eventsController!.eventsCopy.clear();
        if (events.isNotEmpty) {
          eventsController!.eventsCopy.addAll(events);
        } else {}

        eventsController!.setState();
      },
      startDay: WeekDays.sunday, // To change the first day of the week.
      // This callback will only work if cellBuilder is null.
      onEventTap: (event, date) => print(event),
      onDateLongPress: (date) => print(date),
    );
  }

  getWeekView() {
    return WeekView(
      controller: eventsController!.eventController,
      eventTileBuilder: (date, events, boundry, start, end) {
        // Return your widget to display as event tile.
        return Container();
      },
      fullDayEventBuilder: (events, date) {
        // Return your widget to display full day event view.
        return Container();
      },
      showLiveTimeLineInAllDays:
          true, // To display live time line in all pages in week view.
      width: 400, // width of week view.
      minDay: DateTime(1990),
      maxDay: DateTime(2050),
      initialDay: DateTime(2021),
      heightPerMinute: 1, // height occupied by 1 minute time span.
      eventArranger:
          const SideEventArranger(), // To define how simultaneous events will be arranged.
      onEventTap: (events, date) => print(events),
      onDateLongPress: (date) => print(date),
      startDay: WeekDays.sunday, // To change the first day of the week.
    );
  }

  List<String> toFilter = ['Monthly', 'Weekly', 'Daily'];
  int selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventsController ??= context.read<EventsController>();
    getEventss();
  }

  getEventss() async {
    try {
      await eventsController!.getEvents();
    } catch (e) {}
  }

  EventsController? eventsController;

  @override
  Widget build(BuildContext context) {
    eventsController ??= context.read<EventsController>();
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   title: Text('Event Calendar',
        //       style: TextStyle(color: context.iconColor)),
        // ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              // Center(
              //   child: SizedBox(
              //       height: MediaQuery.of(context).size.height * 0.05,
              //       width: MediaQuery.of(context).size.width,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           for (int i = 0; i < toFilter.length; i++) ...{
              //             ElevatedButton(
              //                 onPressed: () {
              //                   setState(() {
              //                     selectedIndex = i;
              //                   });
              //                 },
              //                 child: Text(toFilter[i])),
              //             const SizedBox(
              //               width: 10,
              //             )
              //           }
              //         ],
              //       )),
              // ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: context.height() * 0.4,
                child: context.watch<EventsController>().gettingEvents
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : selectedIndex == 0
                        ? getMonthVIew()
                        : selectedIndex == 1
                            ? getWeekView()
                            : getDayView(),
              ),
              if (eventsController!.selectedDate != null)
                Text(
                  'Events for ${eventsController!.selectedDate!.day}/${eventsController!.selectedDate!.month}/${eventsController!.selectedDate!.year}:',
                  style: TextStyle(
                      color: context.iconColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              if (eventsController!.eventsCopy.isNotEmpty)
                SizedBox(
                  height: context.height() * 0.4,
                  child: context.watch<EventsController>().eventsCopy.isEmpty
                      ? Center(
                          child: Text(
                            'No events found!',
                            style: TextStyle(
                                color: context.iconColor,
                                fontFamily: svFontRoboto),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: eventsController!.eventsCopy.length,
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Card(
                                color:
                                    eventsController!.eventsCopy[index].color,
                                child: ListTile(
                                  title: Text(
                                    eventsController!.eventsCopy[index].title,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                      '${eventsController!.eventsCopy[index].startTime!.hour}:${eventsController!.eventsCopy[index].startTime!.minute} - ${eventsController!.eventsCopy[index].endTime!.hour}:${eventsController!.eventsCopy[index].endTime!.minute}',
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  dense: true,
                                ),
                              ),
                            );
                          },
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
