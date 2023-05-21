import 'dart:io';

import 'package:biit_social/Controllers/DropDowncontroler.dart';
import 'package:biit_social/Controllers/PostController.dart';
import 'package:biit_social/Controllers/SettingController.dart';
import 'package:biit_social/TimeTable/TimeTableScreen.dart';
import 'package:biit_social/utils/SVConstants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/screens/home/components/SVPostComponent.dart';
import 'package:biit_social/utils/SVCommon.dart';
import '../DropDown/CustomDropDown.dart';
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

  final GlobalKey _parentKey = GlobalKey();
  late SettingController settingController;
  late PostController postController;
  @override
  Widget build(BuildContext context) {
    postController = context.read<PostController>();
    settingController = context.read<SettingController>();
    return Scaffold(
      backgroundColor: svGetScaffoldColor(),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                  Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      decoration: boxDecorationDefault(),
                      height: context.height() * 0.1,
                      child: FittedBox(
                        child: Row(
                          children: [
                            Text(
                              'All',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: svFontRoboto),
                            ),
                            SizedBox(
                              height: context
                                      .watch<DropDownController>()
                                      .selectedList
                                      .isEmpty
                                  ? 120
                                  : 200,
                              child: CustomExample0(
                                scrollController: ScrollController(),
                              ),
                            ),
                          ],
                        ),
                      )
                      // child: ListTile(
                      //   trailing: const Icon(Icons.filter_alt_outlined),
                      //   title: Text(
                      //     settingController.classWallFilter,
                      //     maxLines: 2,
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // ),
                      )
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
                          height: context
                                  .watch<PostController>()
                                  .timeTable
                                  .isNotEmpty
                              ? context.height() * 0.4
                              : context.height() * 0.15,
                          child: const TimeTableScreen(),
                        ),
                      ]),
                } else ...{
                  if (context.watch<SettingController>().selectedWall ==
                      '3') ...{
                    Center(
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
                                settingController.selectedWall = '7';
                                settingController.notifyListeners();
                              },
                              child: const Text('Callender'))
                        ],
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
                                postController.timeTable.isNotEmpty
                            ? MediaQuery.of(context).size.height * 0.4
                            : MediaQuery.of(context).size.height * 0.91,
                    child: const SVPostComponent()),
                16.height,
              ],
            ),
          ),
          // const Positioned(bottom: 10, child: SvBottomNavigation())
        ],
      ),
    );
  }
}
