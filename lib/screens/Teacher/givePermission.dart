import 'package:biit_social/utils/SVCommon.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Controllers/DropDowncontroler.dart';
import 'package:provider/provider.dart';

import '../../Controllers/SettingController.dart';
import '../../utils/IPHandleClass.dart';
import '../../utils/SVConstants.dart';
import '../DropDown/CustomDropDown.dart';

class SVGivePermission extends StatefulWidget {
  const SVGivePermission({super.key});

  @override
  State<SVGivePermission> createState() => _SVGivePermissionState();
}

class _SVGivePermissionState extends State<SVGivePermission> {
  List<Items> items = [Items(id: 1, name: 'Nazaid')];
  List<Items> items1 = [
    Items(id: 1, name: 'Full controll'),
    Items(id: 2, name: 'Add posts'),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    IPHandle.settingController = context.read<SettingController>();
    dropDownController ??= context.read<DropDownController>();
    dropDownController!.getTeachersAndStudents();
  }

  DropDownController? dropDownController;
  String? selectedTeacher = '';
  @override
  Widget build(BuildContext context) {
    dropDownController ??= context.read<DropDownController>();
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 100,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
          onPressed: () {
            if (dropDownController!.selectedList.isNotEmpty &&
                selectedTeacher != null &&
                selectedTeacher != '') {
              String toSave = '';
              for (var element in dropDownController!.selectedList) {
                toSave += element.value + ",";
              }
              dropDownController!.saveTAs(FormData.fromMap(
                  {'students': toSave, 'teacher': selectedTeacher}));
            } else if (selectedTeacher.isEmptyOrNull) {
              EasyLoading.showToast('Please select teacher!',
                  dismissOnTap: true);
            } else {
              EasyLoading.showToast('Please select one or more students!',
                  dismissOnTap: true);
            }
          },
          child: Row(
            children: const [
              Icon(Icons.add),
              SizedBox(
                width: 10,
              ),
              Text('Save')
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        bottom: context.watch<SettingController>().isConnected
            ? null
            : PreferredSize(
                preferredSize: Size(context.width(), context.width() * 0.01),
                child: Container(
                  height: context.height() * 0.013,
                  width: context.width(),
                  color: Colors.red,
                  child: FittedBox(
                    child: Center(
                        child: Text(
                      'No internet connection!',
                      style: TextStyle(
                          fontFamily: svFontRoboto, color: Colors.white),
                    )),
                  ),
                )),
        title: Text(
          'Permissions',
          style: TextStyle(color: context.primaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 40),
        child: context.watch<DropDownController>().isGetting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                        iconColor: context.iconColor,
                        hintText: 'Select Teacher',
                        label: Text(
                          'Teacher',
                          style: TextStyle(color: context.iconColor),
                        ),
                        hintStyle: TextStyle(color: context.iconColor)),
                    items: dropDownController!.teachers
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedTeacher = value!;
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomExample0(
                    scrollController: ScrollController(),
                  ),
                  //ElevatedButton(onPressed: () {}, child: const Text('Save'))
                ],
              ),
      ),
    );
  }
}
