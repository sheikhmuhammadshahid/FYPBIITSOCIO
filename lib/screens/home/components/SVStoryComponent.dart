import 'dart:io';

import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:biit_social/screens/home/screens/SVStoryScreen.dart';
import 'package:biit_social/utils/SVColors.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:biit_social/utils/SVConstants.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../fragments/SVAddPostFragment.dart';

class SVStoryComponent extends StatefulWidget {
  const SVStoryComponent({super.key});

  @override
  State<SVStoryComponent> createState() => _SVStoryComponentState();
}

class _SVStoryComponentState extends State<SVStoryComponent> {
  File? image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSocieties();
  }

  getSocieties() {
    context.read<FriendsStoriesController>().getSocietiesDetail();
  }

  late FriendsStoriesController controller;
  @override
  Widget build(BuildContext context) {
    controller = context.read<FriendsStoriesController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (context.watch<FriendsStoriesController>().isMentor)
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 90,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  color: SVAppColorPrimary,
                  borderRadius: radius(SVAppCommonRadius),
                ),
                child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SVAddPostFragment(isStatus: true),
                          ));
                    }),
              ),
              10.height,
              Text('Your Story',
                  style: secondaryTextStyle(
                      size: 12,
                      color: context.iconColor,
                      weight: FontWeight.w500)),
            ],
          ),
        !context.watch<FriendsStoriesController>().storiesLoading
            ? SizedBox(
                width: !controller.isMentor
                    ? context.width() * 0.9
                    : controller.societies.isNotEmpty
                        ? MediaQuery.of(context).size.width * 0.78
                        : MediaQuery.of(context).size.width * 0.6,
                child: controller.societies.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: HorizontalList(
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          spacing: 16,
                          itemCount: controller.societies.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: SVAppColorPrimary, width: 2),
                                    borderRadius: radius(14),
                                  ),
                                  child: controller
                                              .societies[index].profileImage !=
                                          ""
                                      ? Image.network(
                                          profileimageAddress +
                                              controller
                                                  .societies[index].profileImage
                                                  .validate(),
                                          height: 90,
                                          width: 80,
                                          fit: BoxFit.cover,
                                        ).cornerRadiusWithClipRRect(
                                          SVAppCommonRadius)
                                      : Image.asset(
                                          'images/socialv/faces/face_1.png'
                                              .validate(),
                                          height: 90,
                                          width: 80,
                                          fit: BoxFit.cover,
                                        ).cornerRadiusWithClipRRect(
                                          SVAppCommonRadius),
                                ).onTap(() {
                                  controller.index = index;
                                  const SVStoryScreen().launch(context);
                                }),
                                10.height,
                                Text(
                                    controller.societies[index].name.validate(),
                                    style: secondaryTextStyle(
                                        size: 12,
                                        color: context.iconColor,
                                        weight: FontWeight.w500)),
                              ],
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Text(
                          'No stories found!',
                          style: primaryTextStyle(),
                        ),
                      ),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width * 0.78,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: HorizontalList(
                    reverse: true,
                    physics: const BouncingScrollPhysics(),
                    spacing: 16,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 80,
                                color: Colors.white,
                                height: 90,
                              ),
                            ),
                            10.height,
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: Colors.white,
                                height: 10,
                                width: 80,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
      ],
    );
  }
}
