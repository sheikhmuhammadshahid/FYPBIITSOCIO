import 'dart:io';

import 'package:biit_social/Controllers/PostController.dart';
import 'package:biit_social/Controllers/SettingController.dart';
import 'package:biit_social/TimeTable/TimeTableScreen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/screens/home/components/SVPostComponent.dart';
import 'package:biit_social/utils/SVCommon.dart';
import '../DropDown/customSelectBottom.dart';
import '../home/components/SVStoryComponent.dart';
import 'package:provider/provider.dart';

class SVHomeFragment extends StatefulWidget {
  const SVHomeFragment({
    super.key,
  });

  @override
  State<SVHomeFragment> createState() => _SVHomeFragmentState();
}

class _SVHomeFragmentState extends State<SVHomeFragment> {
  File? image;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(svGetScaffoldColor());
    });
  }

  TextEditingController controller = TextEditingController();
  final GlobalKey _parentKey = GlobalKey();
  late SettingController settingController;
  late PostController postController;

  @override
  Widget build(BuildContext context) {
    postController = context.read<PostController>();

    settingController = context.read<SettingController>();
    postController.classWallFilter = '';
    return Scaffold(
      backgroundColor: svGetScaffoldColor(),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Consumer<SettingController>(
              builder: (context, value, child) {
                return Column(
                  children: [
                    if (settingController.selectedWall == "6") ...{
                      5.height,
                      const SVStoryComponent(),
                    },
                  ],
                );
              },
            ),
            if (settingController.selectedWall == "5") ...{
              const CustomDropDown()
            },
            if (settingController.selectedWall == loggedInUser!.userType &&
                loggedInUser!.userType != '3') ...{
              ExpansionTile(
                  onExpansionChanged: (value) {
                    settingController.expansionChanged = value;
                    settingController.notifyListeners();
                  },
                  iconColor: context.iconColor,
                  title: Text(
                    'TimeTable',
                    style: TextStyle(color: context.iconColor),
                  ),
                  children: [
                    SizedBox(
                      height: context.watch<PostController>().timeTable != null
                          ? context.height() * 0.4
                          : context.height() * 0.15,
                      child: const TimeTableScreen(),
                    ),
                  ]),
            } else ...{
              if (context.watch<SettingController>().selectedWall == '3') ...{
                Center(
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.primaryColor,
                            ),
                            onPressed: () {
                              settingController.selectedWall = '9';
                              settingController.notifyListeners();
                            },
                            child: const Text('DateSheet')),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.primaryColor,
                            ),
                            onPressed: () {
                              settingController.selectedWall = '10';
                              settingController.notifyListeners();
                            },
                            child: const Text('TimeTable')),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.primaryColor,
                            ),
                            onPressed: () {
                              settingController.selectedWall = '7';
                              settingController.notifyListeners();
                            },
                            child: const Text('Callender'))
                      ],
                    ),
                  ),
                )
              }
            },
            SizedBox(
                height: settingController.selectedWall == "6"
                    ? MediaQuery.of(context).size.height * 0.77
                    : context.watch<SettingController>().expansionChanged &&
                            settingController.selectedWall ==
                                loggedInUser!.userType &&
                            postController.timeTable == null
                        ? MediaQuery.of(context).size.height * 0.4
                        : MediaQuery.of(context).size.height * 0.89,
                child: const SVPostComponent()),
            16.height,
          ],
        ),
      ),
    );
  }
}
