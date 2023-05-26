import 'package:biit_social/utils/SVConstants.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Date Sheet',
          style: TextStyle(
            fontFamily: svFontRoboto,
            fontSize: 20,
            color: context.iconColor,
          ),
        ),
      ),
      body: SizedBox(
        height: context.height() * 0.73,
        child: SingleChildScrollView(
          child: Consumer<DateSheetCallender>(
            builder: (context, value, child) {
              return value.isDateLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : value.dateSheetsBy.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: value.days
                              .map((e) => getDateSheetWidget(value, e))
                              .toList(),
                        )
                      : const Text('DateSheet not found!');
            },
          ),
        ),
      ),
    );
  }

  Widget getDateSheetWidget(DateSheetCallender controller, day) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
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
          ),
          for (int i = 0; i < controller.dateSheetsBy.length; i++) ...{
            controller.dateSheetsBy[i].dateSheet
                    .any((element) => element.day.contains(day))
                ? Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Card(
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          controller.dateSheetsBy[i].time.splitBefore('~'),
                          style: TextStyle(
                              fontFamily: svFontRoboto, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),

            controller.dateSheetsBy[i].dateSheet
                    .any((element) => element.day.contains(day))
                ? Padding(
                    padding: const EdgeInsets.only(left: 30, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.dateSheetsBy[i].dateSheet
                          .map(
                            (e) => e.day.contains(day)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Divider(
                                          color: Colors.black,
                                          indent: 16,
                                          endIndent: 16,
                                          height: 20),
                                      Text(e.paper),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          )
                          .toList(),
                    ),
                  )
                : const SizedBox.shrink()
            // for (int j = 0;
            //     j < controller.dateSheetsBy[i].dateSheet.length;
            //     j++) ...{
            //   Padding(
            //     padding: const EdgeInsets.only(left: 30),
            //     child: controller.dateSheetsBy[i].dateSheet[j].day.contains(day)
            //         ? Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               const Divider(indent: 16, endIndent: 16, height: 30),
            //               Text(controller.dateSheetsBy[i].dateSheet[j].paper),
            //             ],
            //           )
            //         : const SizedBox.shrink(),
            //   )
            // }
          }
        ],
      ),
    );
  }
  // getDateSheetTable(){
  //   return Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: ListView.builder(
  //                             physics: const NeverScrollableScrollPhysics(),
  //                             shrinkWrap: true,
  //                             itemCount: value.dateSheetsBy.length,
  //                             itemBuilder: (context, index) {
  //                               var col = getColumns();
  //                               var ro = getRows(value, index);
  //                               return value
  //                                       .dateSheetsBy[index].dateSheet.isEmpty
  //                                   ? const SizedBox.shrink()
  //                                   : Column(children: [
  //                                       if (value.dateSheetsBy[index].dateSheet
  //                                           .isNotEmpty) ...{
  //                                         10.height,
  //                                         Text(
  //                                           value.dateSheetsBy[index].time
  //                                               .split('~')[0],
  //                                           style: TextStyle(
  //                                               fontFamily: svFontRoboto),
  //                                         ),
  //                                         10.height,
  //                                         Text(value.dateSheetsBy[index]
  //                                             .dateSheet[0].venue),
  //                                         10.height,
  //                                       },
  //                                       Container(
  //                                         color:
  //                                             context.scaffoldBackgroundColor,
  //                                         height: value.dateSheetsBy[index]
  //                                                 .dateSheet.isEmpty
  //                                             ? 100
  //                                             : context.height() * 0.4,
  //                                         child: PlutoGrid(
  //                                           mode: PlutoGridMode.select,
  //                                           onSelected: (event) =>
  //                                               EasyLoading.showToast(
  //                                                   event.cell!.value,
  //                                                   dismissOnTap: true),
  //                                           configuration:
  //                                               PlutoGridConfiguration(
  //                                             style: PlutoGridStyleConfig(
  //                                               gridBackgroundColor: context
  //                                                   .scaffoldBackgroundColor,
  //                                               iconColor: context.iconColor,

  //                                               rowColor: context
  //                                                   .scaffoldBackgroundColor,
  //                                               borderColor: Colors.black,
  //                                               gridBorderColor: Colors.black,
  //                                               gridBorderRadius:
  //                                                   BorderRadius.circular(12),
  //                                               //rowColor: btnColor,

  //                                               columnTextStyle:
  //                                                   const TextStyle(
  //                                                       fontWeight:
  //                                                           FontWeight.w900),
  //                                               cellTextStyle: const TextStyle(
  //                                                   fontWeight:
  //                                                       FontWeight.w900),
  //                                               activatedBorderColor:
  //                                                   Colors.black,
  //                                               enableGridBorderShadow: true,
  //                                             ),
  //                                           ),
  //                                           columns: col,
  //                                           noRowsWidget: const Center(
  //                                               child: Text(
  //                                                   'DateSheet will be shown here!')),
  //                                           rows: ro,
  //                                           onChanged: (PlutoGridOnChangedEvent
  //                                               event) {},
  //                                           onLoaded: (PlutoGridOnLoadedEvent
  //                                               event) {},
  //                                         ),
  //                                       ),
  //                                     ]);
  //                             }),
  //                       );

  // }
}
