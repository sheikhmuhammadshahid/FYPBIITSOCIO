import 'dart:convert';

import 'package:biit_social/TimeTable/TimeTableModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'package:biit_social/Controllers/PostController.dart';

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({super.key});

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  TextEditingController text = TextEditingController();
  final _rows = <PlutoRow>[];
  final _columns = <PlutoColumn>[];
  getColumns() {
    _columns.add(
      PlutoColumn(
          title: 'Slot',
          backgroundColor: context.scaffoldBackgroundColor,
          field: '1',
          width: context.width() * 0.37,
          type: PlutoColumnType.text(),
          enableColumnDrag: false),
    );

    return _columns.add(PlutoColumn(
        backgroundColor: context.scaffoldBackgroundColor,
        enableColumnDrag: false,
        title: getWeekday(DateTime.now().weekday),
        field: '2',
        width: context.width() * 0.58,
        type: PlutoColumnType.text()));
  }

  @override
  void initState() {
    super.initState();

    // _loadData();
  }

  // getData(d, TimeTableModel item) {
  //   return item.Day.toString().toLowerCase().startsWith(d)
  //       ? '${item.courseName} ${item.teacherName}'
  //       : '-';
  // }

  getRows(PostController value) {
    if (value.timeTable == null) {
      return _rows.clear();
    }
    String day = getWeekday(DateTime.now().weekday);
    _rows.clear();
    List<TimeTableSlot> data = [];
    if (day.toLowerCase().contains('fri')) {
      data = value.timeTable!.friday;
    } else if (day.toLowerCase().contains('mon')) {
      data = value.timeTable!.monday;
    } else if (day.toLowerCase().contains('tue')) {
      data = value.timeTable!.tuesday;
    } else if (day.toLowerCase().contains('wedn')) {
      data = value.timeTable!.wednesday;
    } else if (day.toLowerCase().contains('thur')) {
      data = value.timeTable!.thursday;
    }

    for (var ele in data) {
      _rows.add(PlutoRow(
        cells: {
          '1': PlutoCell(
            value: ele.slot,
          ),
          '2': PlutoCell(value: ele.data),
        },
      ));
    }
    return _rows;
  }

  @override
  Widget build(BuildContext context) {
    //var DataRepository;
    return Consumer<PostController>(
      builder: (context, value, child) {
        getRows(value);
        getColumns();
        return Container(
          color: context.scaffoldBackgroundColor,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // const OfficersScreen(),
                  Container(
                    color: context.scaffoldBackgroundColor,
                    height: value.timeTable == null ? 100 : 300,
                    child: PlutoGrid(
                      onSelected: (event) =>
                          event.cell!.value ??
                          EasyLoading.showToast(event.cell!.value),
                      mode: PlutoGridMode.readOnly,
                      configuration: PlutoGridConfiguration(
                        style: PlutoGridStyleConfig(
                          iconColor: context.iconColor,

                          rowColor: context.scaffoldBackgroundColor,
                          borderColor: Colors.black,
                          gridBorderColor: Colors.black,
                          gridBorderRadius: BorderRadius.circular(12),
                          //rowColor: btnColor,
                          columnTextStyle:
                              const TextStyle(fontWeight: FontWeight.w900),
                          cellTextStyle:
                              const TextStyle(fontWeight: FontWeight.w900),
                          activatedBorderColor: Colors.black,
                          enableGridBorderShadow: true,
                        ),
                      ),
                      columns: _columns,
                      noRowsWidget: const Center(
                          child: Text('TimeTable will be shown here!')),
                      rows: _rows,
                      onChanged: (PlutoGridOnChangedEvent event) {},
                      onLoaded: (PlutoGridOnLoadedEvent event) {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

String getWeekday(int weekday) {
  switch (weekday) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return '';
  }
}

class slot {
  String slott;
  String monday;
  String tuesday;
  String wednesday;
  String Thursday;
  String friday;
  slot({
    required this.slott,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.Thursday,
    required this.friday,
  });

  slot copyWith({
    String? slott,
    String? monday,
    String? tuesday,
    String? wednesday,
    String? Thursday,
    String? friday,
  }) {
    return slot(
      slott: slott ?? this.slott,
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      Thursday: Thursday ?? this.Thursday,
      friday: friday ?? this.friday,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'slott': slott});
    result.addAll({'monday': monday});
    result.addAll({'tuesday': tuesday});
    result.addAll({'wednesday': wednesday});
    result.addAll({'Thursday': Thursday});
    result.addAll({'friday': friday});

    return result;
  }

  factory slot.fromMap(Map<String, dynamic> map) {
    return slot(
      slott: map['slott'] ?? '',
      monday: map['monday'] ?? '',
      tuesday: map['tuesday'] ?? '',
      wednesday: map['wednesday'] ?? '',
      Thursday: map['Thursday'] ?? '',
      friday: map['friday'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory slot.fromJson(String source) => slot.fromMap(json.decode(source));

  @override
  String toString() {
    return 'slot(slott: $slott, monday: $monday, tuesday: $tuesday, wednesday: $wednesday, Thursday: $Thursday, friday: $friday)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is slot &&
        other.slott == slott &&
        other.monday == monday &&
        other.tuesday == tuesday &&
        other.wednesday == wednesday &&
        other.Thursday == Thursday &&
        other.friday == friday;
  }

  @override
  int get hashCode {
    return slott.hashCode ^
        monday.hashCode ^
        tuesday.hashCode ^
        wednesday.hashCode ^
        Thursday.hashCode ^
        friday.hashCode;
  }
}
