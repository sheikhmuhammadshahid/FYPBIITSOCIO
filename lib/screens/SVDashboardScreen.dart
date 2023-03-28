import 'package:biit_social/Client.dart';
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

class _SVDashboardScreenState extends State<SVDashboardScreen> {
  // int selectedIndex = 0;

  @override
  void initState() {
    setStatusBarColor(Colors.transparent);
    //ServerClient().connectWithServer();
    super.initState();
    init();
  }

  init() async {
    context.read<ServerClient>().connectWithServer();
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


//  BottomNavigationBar(
//         showSelectedLabels: true,
//         type: BottomNavigationBarType.shifting,
//         items: [
//           BottomNavigationBarItem(
//             icon: Image.asset('images/socialv/icons/ic_Home.png',
//                     height: 24,
//                     width: 24,
//                     fit: BoxFit.cover,
//                     color: context.iconColor)
//                 .paddingTop(12),
//             label: 'Home',
//             activeIcon: Image.asset('images/socialv/icons/ic_HomeSelected.png',
//                     height: 24, width: 24, fit: BoxFit.cover)
//                 .paddingTop(12),
//           ),
//           BottomNavigationBarItem(
//             // icon: const Icon(
//             //   Icons.person,
//             //   size: 30,
//             // ).paddingTop(12),
//             icon: Image.asset('images/socialv/icons/ic_Profile.png',
//                     height: 24,
//                     width: 24,
//                     fit: BoxFit.cover,
//                     color: context.iconColor)
//                 .paddingTop(12),
//             label: 'Admin',
//             activeIcon: Image.asset('images/socialv/icons/ic_Profile.png',
//                     height: 24, width: 24, fit: BoxFit.cover)
//                 .paddingTop(12),
//           ),
//           BottomNavigationBarItem(
//             icon: Image.asset('images/socialv/icons/ic_3User.png',
//                     height: 24,
//                     width: 24,
//                     fit: BoxFit.cover,
//                     color: context.iconColor)
//                 .paddingTop(12),
//             label: 'Groups',
//             activeIcon: Image.asset('images/socialv/icons/ic_3User.png',
//                     height: 24, width: 24, fit: BoxFit.cover)
//                 .paddingTop(12),
//           ),
//           BottomNavigationBarItem(
//             icon: Image.asset('images/socialv/icons/ic_Notification.png',
//                     height: 24,
//                     width: 24,
//                     fit: BoxFit.cover,
//                     color: context.iconColor)
//                 .paddingTop(12),
//             label: 'Notifications',
//             activeIcon: Image.asset(
//                     'images/socialv/icons/ic_NotificationSelected.png',
//                     height: 24,
//                     width: 24,
//                     fit: BoxFit.cover)
//                 .paddingTop(12),
//           ),
//           BottomNavigationBarItem(
//             //icon: const Icon(Icons.class_outlined),
//             icon: Image.asset('images/socialv/classLogo.png',
//                     height: 24, width: 24, fit: BoxFit.cover)
//                 .paddingTop(12),
//             label: 'Class',
//             activeIcon: Image.asset('images/socialv/classLogo.png',
//                     color: const Color.fromARGB(255, 1, 68, 122),
//                     height: 24,
//                     width: 24,
//                     fit: BoxFit.cover)
//                 .paddingTop(12),
//           ),
//         ],
//         onTap: (val) {
//           selectedIndex = val;
//           setState(() {});
//           // if (val == 2) {
//           //   selectedIndex = 0;
//           //   setState(() {});
//           //   const SVAddPostFragment().launch(context);
//           // }
//         },
//         currentIndex: selectedIndex,
//       ),