import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:biit_social/models/SVGroupModel.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/screens/profile/components/SVProfilePostsComponent.dart';
import 'package:biit_social/utils/SVColors.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:biit_social/utils/SVConstants.dart';
import 'package:provider/provider.dart';

import '../components/SVGroupProfile.dart';

class SVGroupProfileScreen extends StatefulWidget {
  Group group;
  SVGroupProfileScreen({super.key, required this.group});

  @override
  State<SVGroupProfileScreen> createState() => _SVGroupProfileScreenState();
}

class _SVGroupProfileScreenState extends State<SVGroupProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetail();
  }

  late FriendsStoriesController friendsStoriesController;
  getDetail() {
    friendsStoriesController = context.read<FriendsStoriesController>();
    friendsStoriesController.getGroupDetail(widget.group.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: svGetScaffoldColor(),
      appBar: AppBar(
        backgroundColor: svGetScaffoldColor(),
        iconTheme: IconThemeData(color: context.iconColor),
        title: Text('Group', style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SVGroupProfile(
              isOfficial: widget.group.isOfficial!,
              url: widget.group.profile,
            ),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.group.name, style: boldTextStyle(size: 20)),
                4.width,
                widget.group.profile == ''
                    ? Image.asset('images/socialv/icons/ic_TickSquare.png',
                        height: 14, width: 14, fit: BoxFit.cover)
                    : Image.network(profileimageAddress + widget.group.profile,
                        height: 14, width: 14, fit: BoxFit.cover),
              ],
            ),
            8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/socialv/icons/ic_GlobeAntarctic.png',
                  height: 16,
                  width: 16,
                  fit: BoxFit.cover,
                  color: context.iconColor,
                ),
                8.width,
                Text(widget.group.isOfficial! ? 'Official' : 'Public Group',
                    style: secondaryTextStyle(color: svGetBodyColor())),
                18.width,
                Image.asset(
                  'images/socialv/icons/ic_Calendar.png',
                  height: 16,
                  width: 16,
                  fit: BoxFit.cover,
                  color: context.iconColor,
                ),
                8.width,
                Text(widget.group.Admin,
                    style: secondaryTextStyle(color: svGetBodyColor())),
              ],
            ),
            16.height,
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: radius(SVAppCommonRadius)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Consumer<FriendsStoriesController>(
                    builder: (context, value, child) => value.isStoriesLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: 100,
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      borderRadius: radius(100)),
                                  child: Image.asset(
                                          'images/socialv/faces/face_2.png',
                                          height: 32,
                                          width: 32,
                                          fit: BoxFit.cover)
                                      .cornerRadiusWithClipRRect(100),
                                ),
                                Positioned(
                                  left: 14,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        borderRadius: radius(100)),
                                    child: Image.asset(
                                            'images/socialv/faces/face_3.png',
                                            height: 32,
                                            width: 32,
                                            fit: BoxFit.cover)
                                        .cornerRadiusWithClipRRect(100),
                                  ),
                                ),
                                Positioned(
                                  left: 30,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        borderRadius: radius(100)),
                                    child: Image.asset(
                                            'images/socialv/faces/face_4.png',
                                            height: 32,
                                            width: 32,
                                            fit: BoxFit.cover)
                                        .cornerRadiusWithClipRRect(100),
                                  ),
                                ),
                                Positioned(
                                  left: 46,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        borderRadius: radius(100)),
                                    child: Image.asset(
                                            'images/socialv/faces/face_5.png',
                                            height: 32,
                                            width: 32,
                                            fit: BoxFit.cover)
                                        .cornerRadiusWithClipRRect(100),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        borderRadius: radius(100)),
                                    child: Image.asset(
                                            'images/socialv/faces/face_1.png',
                                            height: 32,
                                            width: 32,
                                            fit: BoxFit.cover)
                                        .cornerRadiusWithClipRRect(100),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  Consumer<FriendsStoriesController>(
                    builder: (context, value, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        16.width,
                        Text(
                            value.groupUsers.isNotEmpty
                                ? value.groupUsers.length.toString()
                                : '',
                            style:
                                secondaryTextStyle(color: context.iconColor)),
                      ],
                    ),
                  ),
                  28.height,
                  AppButton(
                    shapeBorder:
                        RoundedRectangleBorder(borderRadius: radius(4)),
                    text: 'Left Group',
                    textStyle: boldTextStyle(color: Colors.white),
                    onTap: () {},
                    elevation: 0,
                    color: SVAppColorPrimary,
                    width: context.width() - 64,
                  ),
                  10.height,
                ],
              ),
            ),
            16.height,
            const SVProfilePostsComponent(),
            16.height,
          ],
        ),
      ),
    );
  }
}
