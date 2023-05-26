import 'package:biit_social/Controllers/DateSheetAndCallender.dart';
import 'package:biit_social/TimeTable/TimeTableModel.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../utils/SVConstants.dart';

class ShowTimeTableScreen extends StatefulWidget {
  const ShowTimeTableScreen({super.key});

  @override
  State<ShowTimeTableScreen> createState() => _ShowTimeTableScreenState();
}

class _ShowTimeTableScreenState extends State<ShowTimeTableScreen> {
  late DateSheetCallender postController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postController = context.read<DateSheetCallender>();
    postController.getAllTimeTable();
  }

  List<String> days = [
    'All',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];
  getSlots() {
    List<String> data = postController.timeTable!.slot;
    data.insert(0, 'All');
    return data;
  }

  String? selectedTeacher;
  String? selectedVenue;
  String? selectedSlot;
  String? selectedDay;

  @override
  Widget build(BuildContext context) {
    return context.watch<DateSheetCallender>().isTimeTableLoading
        ? const Text('Loading')
        : postController.timeTable == null
            ? const Center(child: Text('No timeTable found!'))
            : Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: context.height() * 0.2,
                      child: FittedBox(
                        child: Column(
                          children: [
                            SizedBox(
                              height: context.height() * 0.07,
                              child: FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: context.width() * 0.35,
                                      child: getDropDownWidget(
                                          context: context,
                                          hintText: 'select day',
                                          items: days,
                                          onchanged: (value) {
                                            setState(() {
                                              selectedDay = value!;
                                            });
                                          }),
                                    ),
                                    10.width,
                                    SizedBox(
                                      width: context.width() * 0.65,
                                      child: getDropDownWidget(
                                          context: context,
                                          hintText: 'select slot',
                                          items: getSlots(),
                                          onchanged: (value) {
                                            setState(() {
                                              selectedSlot = value!;
                                            });
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            10.height,
                            SizedBox(
                              height: context.height() * 0.07,
                              child: FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: context.width() * 0.35,
                                      child: getDropDownWidget(
                                          context: context,
                                          hintText: 'select venue',
                                          items:
                                              postController.timeTable!.venue,
                                          onchanged: (value) {
                                            setState(() {
                                              selectedVenue = value!;
                                            });
                                          }),
                                    ),
                                    10.width,
                                    SizedBox(
                                      width: context.width() * 0.65,
                                      child: getDropDownWidget(
                                          context: context,
                                          hintText: 'select teacher',
                                          items:
                                              postController.timeTable!.teacher,
                                          onchanged: (value) {
                                            setState(() {
                                              selectedTeacher = value!;
                                            });
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            3.height,
                            Card(
                              color: context.cardColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: const Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text('Show All')),
                            ).onTap(() {
                              setState(() {
                                selectedDay = selectedSlot =
                                    selectedTeacher = selectedVenue = null;
                              });
                            }),
                          ],
                        ),
                      ),
                    ),
                    5.height,
                    Card(
                        child: getRowWidget(
                            TimeTableSlot(data: 'Course_Venue', slot: 'Slot'))),
                    SizedBox(
                      height: context.height() * 0.57,
                      width: context.width(),
                      child: SingleChildScrollView(child: getWidget()),
                    )
                  ],
                ),
              );
  }

  getDropDownWidget(
      {required BuildContext context,
      required List<String> items,
      required String hintText,
      required var onchanged}) {
    return DropdownButtonFormField(
      isExpanded: true,
      decoration: InputDecoration(
          label: Text(hintText.splitAfter(' ').trim()),
          hintText: hintText,
          hintStyle: TextStyle(color: context.iconColor)),
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),
      onChanged: onchanged,
    );
  }

  getCard(day) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          day,
          style: TextStyle(fontFamily: svFontRoboto, color: Colors.white),
        ),
      ),
    );
  }

  Widget getRowWidget(TimeTableSlot e) {
    return Column(children: [
      Container(
        color: context.iconColor,
        height: 1,
        width: context.width(),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: context.width() * 0.25,
            child: Text(e.slot),
          ),
          SizedBox(width: context.width() * 0.35, child: Text(e.data)),
          SizedBox(
              width: context.width() * 0.15,
              child: Text(e.data.split('_')[e.data.split('_').length - 1])),
        ],
      ),
    ]);
  }

  Column getWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedDay.isEmptyOrNull ||
            selectedDay.toString().toLowerCase().startsWith('mon')) ...{
          getColumnForDayAndData('Monday', postController.timeTable!.monday)
        },
        if (selectedDay.isEmptyOrNull ||
            selectedDay.toString().toLowerCase().startsWith('tue')) ...{
          getColumnForDayAndData('Tuesday', postController.timeTable!.tuesday)
        },
        if (selectedDay.isEmptyOrNull ||
            selectedDay.toString().toLowerCase().startsWith('wed')) ...{
          getColumnForDayAndData(
              'Wednesday', postController.timeTable!.wednesday)
        },
        if (selectedDay.isEmptyOrNull ||
            selectedDay.toString().toLowerCase().startsWith('thu')) ...{
          getColumnForDayAndData('Thursday', postController.timeTable!.thursday)
        },
        if (selectedDay.isEmptyOrNull ||
            selectedDay.toString().toLowerCase().startsWith('fri')) ...{
          getColumnForDayAndData('Friday', postController.timeTable!.friday)
        }
      ],
    );
  }

  Column getColumnForDayAndData(String day, List<TimeTableSlot> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getCard(day),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.map((e) => getRowWidget(e)).toList(),
        ),
      ],
    );
  }
}
