import 'package:biit_social/Client.dart';
import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:biit_social/Controllers/SettingController.dart';
import 'package:biit_social/TimeTable/Calender/calenderScreen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:provider/provider.dart';
import '../Controllers/NotificatinsCountController.dart';
import '../Test.dart';
import '../TimeTable/DateSheetScree.dart';
import '../TimeTable/ShowAllTimeTableScreen.dart';
import 'fragments/SVAddPostFragment.dart';
import 'fragments/SVHomeFragment.dart';
import 'fragments/SVNotificationFragment.dart';
import 'fragments/SVProfileFragment.dart';
import 'fragments/SVSearchFragment.dart';
import 'home/components/SVHomeDrawerComponent.dart';

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

  var scaffoldKey = GlobalKey<ScaffoldState>();
  late SettingController settingController;
  final int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    settingController = context.read<SettingController>();

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: context.scaffoldBackgroundColor,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight((check(context) ||
                        (context
                                .watch<FriendsStoriesController>()
                                .isJoinedSociety &&
                            settingController.selectedWall == "6")) &&
                    context.watch<SettingController>().isAppBarVisible
                ? context.height() * 0.06
                : context.height() * 0.01),
            child: Consumer<SettingController>(
              builder: (context, value, child) {
                return Column(
                  children: [
                    if ((check(context) ||
                            (context
                                    .watch<FriendsStoriesController>()
                                    .isJoinedSociety &&
                                settingController.selectedWall == "6")) &&
                        context.watch<SettingController>().isAppBarVisible) ...{
                      16.height,
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return SVProfileFragment(
                                      id: loggedInUser!.CNIC,
                                      user: true,
                                    );
                                  },
                                ));
                              },
                              child: loggedInUser!.profileImage != ""
                                  ? CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          profileimageAddress +
                                              loggedInUser!.profileImage))
                                  : const CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                          'images/socialv/faces/face_5.png'),
                                    ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 + 50,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 2,
                                  foregroundColor:
                                      context.primaryColor.withOpacity(.3),
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      width: 1.5,
                                      color:
                                          context.primaryColor.withOpacity(.8),
                                    ),
                                  ),
                                  backgroundColor:
                                      context.cardColor.withOpacity(.7),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SVAddPostFragment(isStatus: false),
                                      ));
                                },
                                child: Text("What's on your mind?",
                                    style: secondaryTextStyle(
                                      size: 16,
                                      //scolor: context.iconColor,
                                    )),
                              ),
                            ),
                            IconButton(
                              icon: Image.asset(
                                'images/socialv/icons/ic_Camera.png',
                                width: 44,
                                height: 40,
                                fit: BoxFit.fill,
                                color: context.primaryColor.withOpacity(.8),
                              ),
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SVAddPostFragment(isStatus: false),
                                    ));
                              },
                            ),
                          ],
                        ),
                      ),
                    },
                  ],
                );
              },
            ),
          ),
          leading: IconButton(
            icon: Image.asset(
              'images/socialv/icons/ic_More.png',
              width: 18,
              height: 18,
              fit: BoxFit.cover,
              color: context.primaryColor.withOpacity(.8),
            ),
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
          ),
          title: Text(loggedInUser!.name!, style: boldTextStyle(size: 18)),
          actions: [
            if (context.watch<SettingController>().selectedWall == '3' ||
                settingController.selectedWall == '2' ||
                settingController.selectedWall == '1')
              GestureDetector(
                onTap: () {
                  const SVSearchFragment().launch(context);
                },
                child: CircleAvatar(
                  backgroundColor: context.scaffoldBackgroundColor,

                  radius: 10,
                  // backgroundImage:
                  //     const AssetImage('images/socialv/icons/ic_Search.png'),
                  child: Image.asset(
                    'images/socialv/icons/ic_Search.png',
                    color: context.primaryColor.withOpacity(.8),
                  ),
                ),
              ),
            const SizedBox(
              width: 10,
            ),
            //IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SVNotificationFragment();
                }));
              },
              child: CircleAvatar(
                backgroundColor: context.scaffoldBackgroundColor,
                radius: 20,
                child: Badge(
                  isLabelVisible: context
                          .watch<NotificationCountController>()
                          .notificationsCount !=
                      0,
                  label: Text(context
                      .watch<NotificationCountController>()
                      .notificationsCount
                      .toString()),
                  child: Icon(
                    Icons.notifications,
                    color: context.primaryColor.withOpacity(.8),
                  ),
                ),

                // backgroundImage: AssetImage('images/socialv/icons/ic_User.png'),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Consumer<SettingController>(
              builder: (context, value, child) {
                return (settingController.selectedWall !=
                        loggedInUser!.userType)
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return SVProfileFragment(
                                id: loggedInUser!.CNIC,
                                user: true,
                              );
                            },
                          ));
                        },
                        child: loggedInUser!.profileImage != ""
                            ? CircleAvatar(
                                radius: 15,
                                backgroundImage: NetworkImage(
                                    profileimageAddress +
                                        loggedInUser!.profileImage))
                            : const CircleAvatar(
                                radius: 15,
                                backgroundImage: AssetImage(
                                    'images/socialv/faces/face_5.png'),
                              ),
                      )
                    : const SizedBox.shrink();
              },
            ),

            const SizedBox(
              width: 10,
            )
          ],
        ),
        drawer: Drawer(
          backgroundColor: context.cardColor,
          child: const SVHomeDrawerComponent(),
        ),
        backgroundColor: svGetScaffoldColor(),
        body: context.watch<SettingController>().selectedWall == '7'
            ? const CalenderScreen()
            : context.watch<SettingController>().selectedWall == '9'
                ? const DateSheetScreen()
                : context.watch<SettingController>().selectedWall == '10'
                    ? const ShowTimeTableScreen()
                    : const SVHomeFragment(),
        extendBody: true,
        bottomNavigationBar: const ScrollHideNavigationBar());
    // bottomNavigationBar: const Padding(
    //     padding: EdgeInsets.only(bottom: 10), child: SvBottomNavigation()));
  }

  bool check(BuildContext context) {
    var checkingFrom = context.watch<SettingController>().selectedWall;
    if ((checkingFrom == loggedInUser!.userType ||
            checkingFrom == '5' ||
            settingController.selectedWall == '2' ||
            settingController.selectedWall == '1') &&
        loggedInUser!.userType == '3') {
      return true;
    } else if ((settingController.selectedWall == loggedInUser!.userType ||
            settingController.selectedWall == '5' ||
            settingController.selectedWall == '1') &&
        loggedInUser!.userType == '2') {
      return true;
    } else if ((settingController.selectedWall == loggedInUser!.userType ||
            settingController.selectedWall == '5') &&
        loggedInUser!.userType == "1") {
      return true;
    }
    return false;
  }
}
