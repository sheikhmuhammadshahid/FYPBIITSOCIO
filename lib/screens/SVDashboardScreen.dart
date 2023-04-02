import 'package:biit_social/Client.dart';
import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:biit_social/Controllers/SettingController.dart';
import 'package:biit_social/TimeTable/Calender/calenderScreen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:provider/provider.dart';

import '../BottomNavigation/SvBottomNavigationBar.dart';
import 'fragments/SVHomeFragment.dart';

class SVDashboardScreen extends StatefulWidget {
  const SVDashboardScreen({super.key});

  @override
  State<SVDashboardScreen> createState() => _SVDashboardScreenState();
}

class _SVDashboardScreenState extends State<SVDashboardScreen>
    with WidgetsBindingObserver {
  // int selectedIndex = 0;

  @override
  void initState() {
    setStatusBarColor(Colors.transparent);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //ServerClient().connectWithServer();

    init();
  }

  late ServerClient controller;
  init() async {
    friendsStoriesController = context.read<FriendsStoriesController>();
    await friendsStoriesController!.getFriends();
    // ignore: use_build_context_synchronously
    controller = context.read<ServerClient>();
    controller.connectWithServer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    controller.appLifecycleState = state;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //settingController.dispose();
    super.dispose();
  }

  late SettingController settingController;

  @override
  Widget build(BuildContext context) {
    settingController = context.read<SettingController>();

    return Scaffold(
        backgroundColor: svGetScaffoldColor(),
        body: settingController.selectedWall == '7'
            ? const CalenderScreen()
            : const SVHomeFragment(),
        extendBody: true,
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Consumer<SettingController>(
              builder: (context, value, child) {
                return const SvBottomNavigation();
              },
            )));
  }
}
