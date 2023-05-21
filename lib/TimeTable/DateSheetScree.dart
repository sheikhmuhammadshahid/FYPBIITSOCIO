import 'package:biit_social/utils/SVConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

import '../Controllers/DateSheetAndCallender.dart';

class DateSheetScreen extends StatefulWidget {
  const DateSheetScreen({super.key});

  @override
  State<DateSheetScreen> createState() => _DateSheetScreenState();
}

class _DateSheetScreenState extends State<DateSheetScreen> {
  final _rows = <PlutoRow>[];
  final _columns = <PlutoColumn>[];
  getColumns() {
    _columns.clear();
    _columns.add(PlutoColumn(
        backgroundColor: context.scaffoldBackgroundColor,
        enableColumnDrag: false,
        title: 'Day',
        field: '1',
        width: context.width() * 0.4,
        type: PlutoColumnType.text()));
    return _columns.add(PlutoColumn(
        backgroundColor: context.scaffoldBackgroundColor,
        enableColumnDrag: false,
        title: 'Course',
        field: '2',
        width: context.width() * 0.55,
        type: PlutoColumnType.text()));
  }

  getRows(DateSheetCallender value) {
    _rows.clear();

    for (var ele in value.datesheet) {
      _rows.add(PlutoRow(
        cells: {
          '1': PlutoCell(
            value: ele.day,
          ),
          "2": PlutoCell(value: ele.paper)
        },
      ));
    }
    return _rows;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<DateSheetCallender>().getDateSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Date Sheet',
              style: TextStyle(
                fontFamily: svFontRoboto,
                fontSize: 20,
                color: context.iconColor,
              ),
            ),
            Consumer<DateSheetCallender>(
              builder: (context, value, child) {
                getColumns();
                getRows(value);
                return value.isDateLoading
                    ? Center(
                        child: CircularProgressGradient(
                          radius: 20,
                          colors: const [
                            Colors.green,
                            Colors.teal,
                            Colors.purple
                          ],
                          stokeWidth: 10,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Container(
                            color: context.scaffoldBackgroundColor,
                            height: value.datesheet.isEmpty
                                ? 100
                                : context.height() * 0.7,
                            child: PlutoGrid(
                              mode: PlutoGridMode.select,
                              onSelected: (event) =>
                                  EasyLoading.showToast(event.cell!.value),
                              configuration: PlutoGridConfiguration(
                                style: PlutoGridStyleConfig(
                                  iconColor: context.iconColor,

                                  rowColor: context.scaffoldBackgroundColor,
                                  borderColor: Colors.black,
                                  gridBorderColor: Colors.black,
                                  gridBorderRadius: BorderRadius.circular(12),
                                  //rowColor: btnColor,

                                  columnTextStyle: const TextStyle(
                                      fontWeight: FontWeight.w900),
                                  cellTextStyle: const TextStyle(
                                      fontWeight: FontWeight.w900),
                                  activatedBorderColor: Colors.black,
                                  enableGridBorderShadow: true,
                                ),
                              ),
                              columns: _columns,
                              noRowsWidget: const Center(
                                  child: Text('DateSheet will be shown here!')),
                              rows: _rows,
                              onChanged: (PlutoGridOnChangedEvent event) {},
                              onLoaded: (PlutoGridOnLoadedEvent event) {},
                            ),
                          ),
                        ]),
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}
