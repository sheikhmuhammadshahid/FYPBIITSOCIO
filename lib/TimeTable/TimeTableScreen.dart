import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:biit_social/Controllers/PostController.dart';
import 'package:biit_social/TimeTable/TimeTableModel.dart';

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({super.key});

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  TextEditingController text = TextEditingController();
  final _rows = <PlutoRow>[];
  final _columns = [
    PlutoColumn(
      title: 'Slot',
      field: '6',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Monday',
      field: '1',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Tuesday',
      field: '2',
      type: PlutoColumnType.text(),
    ),

    PlutoColumn(
      title: 'Wednesday',
      field: '3',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Thursday',
      field: '4',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Friday',
      field: '5',
      type: PlutoColumnType.text(),
    ),

    // PlutoColumn(
    //   title: 'Role',
    //   field: 'role',
    //   type: PlutoColumnType.text(),
    // ),
  ];

  @override
  void initState() {
    super.initState();

    // _loadData();
  }

  getData(d, TimeTableModel item) {
    return item.Day.toString().toLowerCase().startsWith(d)
        ? '${item.courseName} ${item.teacherName}'
        : '-';
  }

  getRows(PostController value) {
    var d = groupBy(value.timeTable, (p0) => p0.slot);
    _rows.clear();
    for (var element in d.values) {
      for (var ele in element) {
        _rows.add(PlutoRow(
          cells: {
            '6': PlutoCell(value: ele.slot),
            '1': PlutoCell(value: getData('mo', element[0])),
            '2': PlutoCell(value: getData('tu', element[1])),
            '3': PlutoCell(value: getData('we', element[2])),
            '4': PlutoCell(value: getData('th', element[3])),
            '5': PlutoCell(value: getData('fr', element[4])),
          },
        ));
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //var DataRepository;
    return Consumer<PostController>(
      builder: (context, value, child) {
        getRows(value);
        return Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // const OfficersScreen(),
                  Container(
                    color: context.scaffoldBackgroundColor,
                    height: value.timeTable.isEmpty ? 100 : 300,
                    child: PlutoGrid(
                      mode: PlutoGridMode.readOnly,
                      configuration: PlutoGridConfiguration(
                        style: PlutoGridStyleConfig(
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
