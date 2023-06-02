import 'package:biit_social/Controllers/AuthController.dart';
import 'package:biit_social/Controllers/SettingController.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/models/SVSearchModel.dart';
import 'package:biit_social/screens/fragments/SVProfileFragment.dart';
import 'package:biit_social/screens/search/components/SVSearchCardComponent.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:provider/provider.dart';

import '../../utils/IPHandleClass.dart';
import '../../utils/SVConstants.dart';

class SVSearchFragment extends StatefulWidget {
  const SVSearchFragment({super.key});

  @override
  State<SVSearchFragment> createState() => _SVSearchFragmentState();
}

class _SVSearchFragmentState extends State<SVSearchFragment> {
  List<SVSearchModel> list = [];

  @override
  void initState() {
    list = getRecentList();
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(svGetScaffoldColor());
    });
    IPHandle.settingController = context.read<SettingController>();
    init();
  }

  late AuthController authController;
  init() {
    authController = context.read<AuthController>();
    authController.userToShow = authController.users = [];
    authController.pageNo = 0;
    settingController ??= context.read<SettingController>();
    authController.getUsers(settingController!);
  }

  SettingController? settingController;
  @override
  Widget build(BuildContext context) {
    settingController ??= context.read<SettingController>();
    return Scaffold(
      backgroundColor: svGetScaffoldColor(),
      appBar: AppBar(
        backgroundColor: svGetScaffoldColor(),
        iconTheme: IconThemeData(color: context.iconColor),
        leadingWidth: 30,
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
        title: Container(
          decoration:
              BoxDecoration(color: context.cardColor, borderRadius: radius(8)),
          child: AppTextField(
            onChanged: (p0) {
              authController.users.isNotEmpty
                  ? authController.filterUsers(p0)
                  : {authController.getUsers(settingController!)};
            },
            textFieldType: TextFieldType.NAME,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search Here',
              hintStyle: secondaryTextStyle(color: svGetBodyColor()),
              prefixIcon: Image.asset('images/socialv/icons/ic_Search.png',
                      height: 16,
                      width: 16,
                      fit: BoxFit.cover,
                      color: svGetBodyColor())
                  .paddingAll(16),
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.95,
        child: Consumer<AuthController>(
          builder: (context, controller, child) {
            return authController.isLoading
                ? getNotificationShimmer(context)
                : authController.userToShow.isNotEmpty
                    ? LazyLoadScrollView(
                        child: RefreshIndicator(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16),
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return SVSearchCardComponent(
                                      element: authController.userToShow[index])
                                  .onTap(() {
                                SVProfileFragment(
                                  id: authController.userToShow[index].CNIC,
                                  user: false,
                                ).launch(context);
                              });
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider(height: 20);
                            },
                            itemCount: authController.userToShow.length,
                          ),
                          onRefresh: () async {
                            authController.pageNo = 0;
                            authController.users.clear();
                            authController.userToShow.clear();
                            await authController.getUsers(settingController!);
                          },
                        ),
                        onEndOfPage: () {
                          authController.getUsers(settingController!);
                        },
                      )
                    : Center(
                        child: Text(
                          'No Users Found!',
                          style: boldTextStyle(),
                        ),
                      );
          },
        ),
      ),
    );
  }
}
