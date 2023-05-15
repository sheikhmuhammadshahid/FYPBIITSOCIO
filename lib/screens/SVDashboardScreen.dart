import 'package:biit_social/Client.dart';
import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:biit_social/Controllers/SettingController.dart';
import 'package:biit_social/TimeTable/Calender/calenderScreen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:provider/provider.dart';
import '../Test.dart';
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
  final int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    settingController = context.read<SettingController>();

    return Scaffold(
        backgroundColor: svGetScaffoldColor(),
        body: context.watch<SettingController>().selectedWall == '7'
            ? const CalenderScreen()
            : const SVHomeFragment(),
        extendBody: true,
        bottomNavigationBar: const ScrollHideNavigationBar());
    // bottomNavigationBar: const Padding(
    //     padding: EdgeInsets.only(bottom: 10), child: SvBottomNavigation()));
  }
}
