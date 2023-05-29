import 'package:biit_social/Controllers/EventsController.dart';
import 'package:biit_social/utils/SVConstants.dart';
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/EventModel.dart';
import '../../utils/SVCommon.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  EventsController? eventsController;
  bool toUpdate = false;
  int colorSelected = -1;
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

        return SingleChildScrollView(
          child: Column(
            children: [
              Text(
                '${date.day}', // Display the day of the month
                style: TextStyle(
                  color: isToday ? Colors.red : context.iconColor,
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
        toUpdate = false;
        eventsController!.eventsCopy.clear();
        if (events.isNotEmpty) {
          eventsController!.eventsCopy.addAll(events);
        } else {}

        eventsController!.setState();
      },

      startDay: WeekDays.sunday, // To change the first day of the week.
      // This callback will only work if cellBuilder is null.
      onEventTap: (event, date) => print(event),
      onDateLongPress: (date) async {
        if (loggedInUser!.userType == '3') {
          colorSelected = -1;
          eventsController!.colorSelected = Colors.black;
          startDate.text = date.toString();
          endDate.text = date.toString();

          await SelectEvent(context, 0);
        }
      },
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
                height: context.watch<EventsController>().gettingEvents
                    ? context.height()
                    : context.height() * 0.4,
                child: eventsController!.gettingEvents
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      margin: const EdgeInsets.all(20),
                                      width: context.width(),
                                      height: context.height() * 0.4,
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      margin: const EdgeInsets.all(10),
                                      width: context.width(),
                                      height: context.height() * 0.1,
                                    );
                            }),
                      )
                    : selectedIndex == 0
                        ? getMonthVIew()
                        : selectedIndex == 1
                            ? getWeekView()
                            : getDayView(),
              ),
              if (eventsController!.selectedDate != null)
                Text(
                  'Events for ${eventsController!.selectedDate!.day}/${eventsController!.selectedDate!.month}/${eventsController!.selectedDate!.year}',
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
                            // ev = eventsController!.eventsCopy[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Card(
                                color:
                                    eventsController!.eventsCopy[index].color,
                                child: ListTile(
                                  trailing: loggedInUser!.userType != '3'
                                      ? const SizedBox.shrink()
                                      : PopupMenuButton(
                                          color: context.cardColor,
                                          itemBuilder: (context) {
                                            return [
                                              PopupMenuItem(
                                                  child: TextButton(
                                                      onPressed: () {
                                                        eventsController!
                                                            .deleteEvent(int.parse(
                                                                eventsController!
                                                                    .eventsCopy[
                                                                        index]
                                                                    .description));
                                                        nameController.text =
                                                            '';
                                                        startDate.text = '';
                                                        endDate.text = '';
                                                        Navigator.pop(context);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.delete,
                                                            color: context
                                                                .iconColor
                                                                .withOpacity(
                                                                    .8),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            'Delete',
                                                            style: boldTextStyle(
                                                                color: context
                                                                    .iconColor),
                                                          ),
                                                        ],
                                                      ))),
                                              PopupMenuItem(
                                                  child: TextButton(
                                                      onPressed: () async {
                                                        nameController.text =
                                                            eventsController!
                                                                .eventsCopy[
                                                                    index]
                                                                .title;
                                                        startDate.text =
                                                            eventsController!
                                                                .eventsCopy[
                                                                    index]
                                                                .startTime
                                                                .toString()
                                                                .replaceAll(
                                                                    'T', ' ');
                                                        endDate.text =
                                                            eventsController!
                                                                .eventsCopy[
                                                                    index]
                                                                .endDate
                                                                .toString()
                                                                .replaceAll(
                                                                    'T', ' ');
                                                        colorSelected =
                                                            colorCollection.indexOf(
                                                                eventsController!
                                                                    .eventsCopy[
                                                                        index]
                                                                    .color);
                                                        eventsController!
                                                                .colorSelected =
                                                            eventsController!
                                                                .eventsCopy[
                                                                    index]
                                                                .color;
                                                        print(colorSelected);
                                                        eventsController!
                                                            .setState();
                                                        toUpdate = true;
                                                        await SelectEvent(
                                                            context,
                                                            int.parse(
                                                                eventsController!
                                                                    .eventsCopy[
                                                                        index]
                                                                    .description));
                                                        nameController.text =
                                                            '';
                                                        startDate.text = '';
                                                        endDate.text = '';
                                                        toUpdate = false;
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.edit,
                                                            color: context
                                                                .iconColor
                                                                .withOpacity(
                                                                    .8),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            'Edit',
                                                            style: boldTextStyle(
                                                                color: context
                                                                    .iconColor),
                                                          ),
                                                        ],
                                                      ))),
                                            ];
                                          },
                                        ),
                                  title: Text(
                                    eventsController!.eventsCopy[index].title,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                      eventsController!
                                                  .eventsCopy[index].startTime
                                                  .toString()
                                                  .splitBefore(' ') !=
                                              eventsController!
                                                  .eventsCopy[index].endDate
                                                  .toString()
                                                  .splitBefore(' ')
                                          ? '${eventsController!.eventsCopy[index].startTime!.toString().splitBefore(' ')} - ${eventsController!.eventsCopy[index].endDate.toString().splitBefore(' ')}'
                                          : eventsController!
                                              .eventsCopy[index].startTime
                                              .toString()
                                              .splitBefore(' '),
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

  selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? dt = await showOmniDateTimePicker(
      context: context,
      initialDate: controller.text.isNotEmpty
          ? DateTime.parse(controller.text.trim())
          : DateTime.now(),
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        if (dateTime == DateTime(2023, 2, 25)) {
          return false;
        } else {
          return true;
        }
      },
    );
    if (dt != null) {
      controller.text = dt.toString();
    }
  }

  Future<dynamic> SelectEvent(BuildContext context, int id) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        icon: Align(
          alignment: Alignment.topRight,
          child: IconButton(
              icon: Icon(
                Icons.cancel,
                color: context.iconColor,
              ),
              onPressed: () {
                context.pop();
              }),
        ),
        backgroundColor: context.cardColor,
        title: Text(toUpdate ? 'Edit Event' : 'Add Event',
            style:
                TextStyle(fontFamily: svFontRoboto, color: context.iconColor)),
        content: SizedBox(
          height: context.height() * 0.3,
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value != null && value != '') {
                          return null;
                        }
                        return 'Please enter name';
                      },
                      controller: nameController,
                      decoration: const InputDecoration(
                          label: Text('Name'), hintText: 'Enter event name'),
                    ),
                    10.height,
                    TextFormField(
                      readOnly: true,
                      controller: startDate,
                      onTap: () {
                        selectDate(context, startDate);
                      },
                      validator: (value) {
                        if (value != null && value != '') {
                          return null;
                        }
                        return 'Please select start date!';
                      },
                      decoration: const InputDecoration(
                          label: Text('Start date'), hintText: 'Start date'),
                    ),
                    10.height,
                    TextFormField(
                      readOnly: true,
                      onTap: () {
                        selectDate(context, endDate);
                      },
                      validator: (value) {
                        if (value != null && value != '') {
                          if (startDate.text.isNotEmpty) {
                            if (DateTime.parse(startDate.text)
                                    .isBefore(DateTime.parse(endDate.text)) ||
                                DateTime.parse(startDate.text).dateYMD ==
                                    (DateTime.parse(endDate.text)).dateYMD) {
                              return null;
                            }
                            return 'End date must be greater than start date!';
                          }
                        }
                        return 'Please select end date!';
                      },
                      controller: endDate,
                      decoration: const InputDecoration(
                          label: Text('end date'), hintText: 'end date'),
                    ),
                    10.height,
                    Wrap(
                        children: colorCollection
                            .map((e) => Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: e,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: context
                                                        .watch<
                                                            EventsController>()
                                                        .colorSelected ==
                                                    e
                                                ? Colors.red
                                                : e,
                                            width: 2)),
                                  ).onTap(() {
                                    colorSelected = colorCollection.indexOf(e);
                                    eventsController!.colorSelected = e;
                                    eventsController!.setState();
                                  }),
                                ))
                            .toList()),
                    10.height,
                  ],
                ),
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (colorSelected != -1) {
                    EventModel event = EventModel(
                        colorId: colorSelected,
                        id: id,
                        startDate: startDate.text,
                        endDate: endDate.text,
                        Name: nameController.text);
                    if (toUpdate) {
                      eventsController!.updateEvent(event);
                    } else {
                      eventsController!.addEvent(event);
                    }
                    colorSelected = -1;
                    nameController.text = '';
                    startDate.text = '';
                    endDate.text = '';
                    context.pop();
                  } else {
                    EasyLoading.showToast('Please select color ',
                        dismissOnTap: true);
                  }
                }
              },
              child: Text(
                toUpdate ? 'Update' : 'Add',
                style: TextStyle(
                    color: context.scaffoldBackgroundColor,
                    fontFamily: svFontRoboto),
              ))
        ],
      ),
    );
  }
}
