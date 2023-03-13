import 'package:biit_social/Controllers/PostController.dart';
import 'package:biit_social/screens/home/components/SVPostComponent.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/screens/home/components/SVForumRepliesComponent.dart';
import 'package:biit_social/screens/home/components/SVForumTopicComponent.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:provider/provider.dart';

class SVDiarScreen extends StatefulWidget {
  const SVDiarScreen({Key? key}) : super(key: key);

  @override
  State<SVDiarScreen> createState() => _SVDiarScreenState();
}

class _SVDiarScreenState extends State<SVDiarScreen> {
  List<String> tabList = ['Topics', 'Replies', 'Engagement', 'Favourite'];

  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    controller = Provider.of<PostController>(context, listen: false);
    controller.fromDiary = true;
  }

  Widget getTabContainer() {
    if (selectedTab == 0) {
      return const SVForumTopicComponent(isFavTab: false);
    } else if (selectedTab == 1) {
      return SVForumRepliesComponent();
    } else if (selectedTab == 2) {
      return const Offstage();
    } else {
      return const SVForumTopicComponent(isFavTab: true);
    }
  }

  late PostController controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.isLoading = false;
        controller.fromDiary = false;
        controller.setState();
        return true;
      },
      child: Scaffold(
        backgroundColor: svGetScaffoldColor(),
        appBar: AppBar(
          backgroundColor: svGetScaffoldColor(),
          iconTheme: IconThemeData(color: context.iconColor),
          title: Text('Diary', style: boldTextStyle(size: 20)),
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: context.cardColor, borderRadius: radius(8)),
                child: AppTextField(
                  textFieldType: TextFieldType.NAME,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search Here',
                    hintStyle: secondaryTextStyle(color: svGetBodyColor()),
                    prefixIcon: Image.asset(
                            'images/socialv/icons/ic_Search.png',
                            height: 16,
                            width: 16,
                            fit: BoxFit.cover,
                            color: svGetBodyColor())
                        .paddingAll(16),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.78,
                  child: const SVPostComponent())

              // HorizontalList(
              //   spacing: 0,
              //   padding: const EdgeInsets.all(16),
              //   itemCount: tabList.length,
              //   itemBuilder: (context, index) {
              //     return AppButton(
              //       shapeBorder: RoundedRectangleBorder(borderRadius: radius(8)),
              //       text: tabList[index],
              //       textStyle: boldTextStyle(
              //           color: selectedTab == index
              //               ? Colors.white
              //               : svGetBodyColor(),
              //           size: 14),
              //       onTap: () {
              //         selectedTab = index;
              //         setState(() {});
              //       },
              //       elevation: 0,
              //       color: selectedTab == index
              //           ? SVAppColorPrimary
              //           : svGetScaffoldColor(),
              //     );
              //   },
              // ),
              //getTabContainer(),
            ],
          ),
        ),
      ),
    );
  }
}
