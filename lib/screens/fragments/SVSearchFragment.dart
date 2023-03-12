import 'package:biit_social/Controllers/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/models/SVSearchModel.dart';
import 'package:biit_social/screens/fragments/SVProfileFragment.dart';
import 'package:biit_social/screens/search/components/SVSearchCardComponent.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:provider/provider.dart';

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
    init();
  }

  late AuthController authController;
  init() {
    authController = Provider.of<AuthController>(context, listen: false);
    authController.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: svGetScaffoldColor(),
      appBar: AppBar(
        backgroundColor: svGetScaffoldColor(),
        iconTheme: IconThemeData(color: context.iconColor),
        leadingWidth: 30,
        title: Container(
          decoration:
              BoxDecoration(color: context.cardColor, borderRadius: radius(8)),
          child: AppTextField(
            onChanged: (p0) {
              authController.users.isNotEmpty
                  ? authController.filterUsers(p0)
                  : {authController.getUsers()};
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
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : authController.userToShow.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          authController.userToShow.isEmpty
                              ? Text('RECENT', style: boldTextStyle())
                                  .paddingAll(16)
                              : const SizedBox(),
                          ListView.separated(
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
                        ],
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
