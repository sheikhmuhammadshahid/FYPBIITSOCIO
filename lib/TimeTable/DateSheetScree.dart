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
  List<PlutoColumn> getColumns() {
    _columns.clear();
    _columns.add(PlutoColumn(
        backgroundColor: context.scaffoldBackgroundColor,
        enableColumnDrag: false,
        title: 'Day',
        field: '1',
        width: context.width() * 0.4,
        type: PlutoColumnType.text()));
    _columns.add(PlutoColumn(
        backgroundColor: context.scaffoldBackgroundColor,
        enableColumnDrag: false,
        title: 'Course',
        field: '2',
        width: context.width() * 0.55,
        type: PlutoColumnType.text()));
    return _columns;
  }

  List<PlutoRow> getRows(DateSheetCallender value, index) {
    _rows.clear();

    for (var ele in value.dateSheetsBy[index].dateSheet) {
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
        child: SingleChildScrollView(
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
                  return value.isDateLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: value.dateSheetsBy.length,
                              itemBuilder: (context, index) {
                                var col = getColumns();
                                var ro = getRows(value, index);
                                return value
                                        .dateSheetsBy[index].dateSheet.isEmpty
                                    ? const SizedBox.shrink()
                                    : Column(children: [
                                        if (value.dateSheetsBy[index].dateSheet
                                            .isNotEmpty) ...{
                                          10.height,
                                          Text(
                                            value.dateSheetsBy[index].time
                                                .split('~')[0],
                                            style: TextStyle(
                                                fontFamily: svFontRoboto),
                                          ),
                                          10.height,
                                          Text(value.dateSheetsBy[index]
                                              .dateSheet[0].venue),
                                          10.height,
                                        },
                                        Container(
                                          color:
                                              context.scaffoldBackgroundColor,
                                          height: value.dateSheetsBy[index]
                                                  .dateSheet.isEmpty
                                              ? 100
                                              : context.height() * 0.4,
                                          child: PlutoGrid(
                                            mode: PlutoGridMode.select,
                                            onSelected: (event) =>
                                                EasyLoading.showToast(
                                                    event.cell!.value,
                                                    dismissOnTap: true),
                                            configuration:
                                                PlutoGridConfiguration(
                                              style: PlutoGridStyleConfig(
                                                gridBackgroundColor: context
                                                    .scaffoldBackgroundColor,
                                                iconColor: context.iconColor,

                                                rowColor: context
                                                    .scaffoldBackgroundColor,
                                                borderColor: Colors.black,
                                                gridBorderColor: Colors.black,
                                                gridBorderRadius:
                                                    BorderRadius.circular(12),
                                                //rowColor: btnColor,

                                                columnTextStyle:
                                                    const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900),
                                                cellTextStyle: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w900),
                                                activatedBorderColor:
                                                    Colors.black,
                                                enableGridBorderShadow: true,
                                              ),
                                            ),
                                            columns: col,
                                            noRowsWidget: const Center(
                                                child: Text(
                                                    'DateSheet will be shown here!')),
                                            rows: ro,
                                            onChanged: (PlutoGridOnChangedEvent
                                                event) {},
                                            onLoaded: (PlutoGridOnLoadedEvent
                                                event) {},
                                          ),
                                        ),
                                      ]);
                              }),
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
