import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  getDayView() {
    return DayView(
      controller: EventController(),
      eventTileBuilder: (date, events, boundry, start, end) {
        // Return your widget to display as event tile.
        return Container();
      },
      fullDayEventBuilder: (events, date) {
        // Return your widget to display full day event view.
        return Container();
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
      onEventTap: (events, date) => print(events),
      onDateLongPress: (date) => print(date),
    );
  }

  getMonthVIew() {
    return MonthView(
      controller: EventController(
        eventFilter: (date, events) => [
          CalendarEventData(
              title: 'data',
              date: DateTime(2023, 1, 3, 3, 3, 4),
              startTime: DateTime(2023, 1, 3, 3, 3, 4),
              endDate: DateTime(2023, 1, 5, 3),
              endTime: DateTime(2023, 1, 5, 3))
        ],
      ),
      pageTransitionCurve: Curves.easeInCirc,
      // to provide custom UI for month cells.
      cellBuilder: (date, events, isToday, isInMonth) {
        // Return your widget to display as month cell.
        return isToday
            ? Column(
                children: [
                  Text(date.day.toString()),
                  Text(events.isNotEmpty ? events[0].title : '')
                ],
              )
            : const Text('');
      },
      minMonth: DateTime(DateTime.now().year),
      maxMonth: DateTime(DateTime.now().year + 1),
      initialMonth: DateTime.now(),
      // /cellAspectRatio: 1,
      onPageChange: (date, pageIndex) => print("$date, $pageIndex"),
      onCellTap: (events, date) {
        // Implement callback when user taps on a cell.
        print(events);
      },
      startDay: WeekDays.sunday, // To change the first day of the week.
      // This callback will only work if cellBuilder is null.
      onEventTap: (event, date) => print(event),
      onDateLongPress: (date) => print(date),
    );
  }

  getWeekView() {
    return WeekView(
      controller: EventController(),
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < toFilter.length; i++) ...{
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedIndex = i;
                                });
                              },
                              child: Text(toFilter[i])),
                          const SizedBox(
                            width: 10,
                          )
                        }
                      ],
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              FittedBox(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: selectedIndex == 0
                      ? getMonthVIew()
                      : selectedIndex == 1
                          ? getWeekView()
                          : getDayView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
