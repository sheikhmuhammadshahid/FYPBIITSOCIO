import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:biit_social/utils/SVConstants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:story_view/story_view.dart';
import 'package:provider/provider.dart';

import '../../../Controllers/StoryController.dart';
import '../../../utils/IPHandleClass.dart';

class SVStoryScreen extends StatefulWidget {
  const SVStoryScreen({super.key});

  @override
  State<SVStoryScreen> createState() => _SVStoryScreenState();
}

class _SVStoryScreenState extends State<SVStoryScreen>
    with TickerProviderStateMixin {
  List<String> imageList = [];
  StoryController storyController = StoryController();

  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    //imageList = widget.story!.storyImages.validate();
    setStatusBarColor(Colors.transparent);
    super.initState();
    init();
  }

  void init() {
    // Provider.of<FriendsStoriesController>(context, listen: false).getStories();
  }
  @override
  void dispose() {
    // TODO: implement dispose

    //provier.dispose();
    //storyController.dispose();

    super.dispose();
  }

  late FriendsStoriesController provier;
  @override
  Widget build(BuildContext context) {
    provier = context.read<FriendsStoriesController>();
    StorysController stryController = context.read<StorysController>();
    return WillPopScope(
      onWillPop: () async {
        provier.index = 0;

        return Future.delayed(const Duration(seconds: 0)).then((value) {
          return true;
        });
      },
      child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.7),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              provier.societies[provier.index].stories!.isEmpty
                  ? Center(
                      child: Text(
                      'No stories!',
                      style: TextStyle(
                          fontFamily: svFontRoboto, color: Colors.white),
                    ))
                  : StoryView(
                      onStoryShow: (valuee) {
                        // int index = provier.societies[provier.index].stories!
                        //     .indexOf(valuee);
                        // try {
                        //   var v = valuee.view.key.toString();
                        //   print(v.splitBetween('<', '>'));
                        //   try {
                        //     stryController.shownStoryIndex =
                        //         int.parse(v.splitBetween('<', '>'));
                        //     stryController.notifyListeners();
                        //   } catch (e) {
                        //     stryController.shownStoryIndex = -1;
                        //     stryController.notifyListeners();
                        //   }
                        // } catch (e) {}

                        // valuee.duration
                      },
                      onComplete: () {
                        context.pop();
                      },
                      storyItems: List.generate(
                          provier.societies[provier.index].stories!.length,
                          (index) {
                        return provier.societies[provier.index].stories![index]
                                    .type ==
                                'text'
                            ? StoryItem.text(
                                key: ValueKey(index),
                                title: provier.societies[provier.index]
                                    .stories![index].text,
                                backgroundColor: Colors.black,
                                duration: const Duration(seconds: 3))
                            : provier.societies[provier.index].stories![index]
                                        .type ==
                                    'image'
                                ? StoryItem.pageImage(
                                    key: ValueKey(index),
                                    imageFit: BoxFit.fill,
                                    url: IPHandle.storyAddress +
                                        provier.societies[provier.index]
                                            .stories![index].url,
                                    controller: storyController)
                                : StoryItem.pageVideo(
                                    key: ValueKey(index),
                                    IPHandle.storyAddress +
                                        provier.societies[provier.index]
                                            .stories![index].url,
                                    caption: provier.societies[provier.index]
                                        .stories![index].text,
                                    controller: storyController);
                      }),
                      progressPosition: ProgressPosition.top,
                      repeat: false,
                      controller: storyController,
                    ),
              Positioned(
                left: 16,
                top: 70,
                child: SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      provier.societies[provier.index].profileImage == ""
                          ? Image.asset(
                              'images/socialv/faces/face_1.png'.validate(),
                              height: 48,
                              width: 48,
                              fit: BoxFit.cover,
                            ).cornerRadiusWithClipRRect(8)
                          : Image.network(
                              IPHandle.imageAddress +
                                  provier.societies[provier.index].profileImage
                                      .validate(),
                              height: 48,
                              width: 48,
                              fit: BoxFit.cover,
                            ).cornerRadiusWithClipRRect(8),
                      16.width,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(provier.societies[provier.index].name.validate(),
                              style: boldTextStyle(color: Colors.white)),
                          5.height,
                          // Text(
                          //   provier.societies[provier.index].stories!.length >
                          //               context
                          //                   .watch<StorysController>()
                          //                   .shownStoryIndex &&
                          //           stryController.shownStoryIndex != -1
                          //       ? DateTime.parse(provier
                          //               .societies[provier.index]
                          //               .stories![
                          //                   stryController.shownStoryIndex]
                          //               .time!
                          //               .replaceAll(' ', 'T')
                          //               .validate())
                          //           .timeAgo
                          //       : '',
                          //   style: secondaryTextStyle(color: Colors.white),
                          // )
                          // svRobotoText(
                          //     text: DateFormat('MM/dd/yyyy h:mm:ss a')
                          //         .parse(provier
                          //             .societies[provier.index]
                          //             .stories![provier.indexShownStory == -1
                          //                 ? 0
                          //                 : provier.indexShownStory]
                          //             .time!)
                          //         .timeAgo,
                          //     color: Colors.white),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              // Row(
              //   children: [
              //     Container(
              //       width: context.width() * 0.76,
              //       padding:
              //           const EdgeInsets.only(left: 16, right: 4, bottom: 16),
              //       child: AppTextField(
              //         controller: messageController,
              //         textStyle: secondaryTextStyle(
              //             fontFamily: svFontRoboto, color: Colors.white),
              //         textFieldType: TextFieldType.OTHER,
              //         decoration: InputDecoration(
              //           hintText: 'Send Message',
              //           hintStyle: secondaryTextStyle(
              //               fontFamily: svFontRoboto, color: Colors.white),
              //           border: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(8),
              //               borderSide: const BorderSide(
              //                   width: 1.0, color: Colors.white)),
              //           enabledBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(8),
              //               borderSide: const BorderSide(
              //                   width: 1.0, color: Colors.white)),
              //           focusedBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(8),
              //               borderSide: const BorderSide(
              //                   width: 1.0, color: Colors.white)),
              //         ),
              //       ),
              //     ),
              //     Image.asset('images/socialv/icons/ic_Send.png',
              //             height: 24,
              //             width: 24,
              //             fit: BoxFit.cover,
              //             color: Colors.white)
              //         .onTap(() {
              //       messageController.clear();
              //     },
              //             splashColor: Colors.transparent,
              //             highlightColor: Colors.transparent),
              //     // IconButton(
              //     //   icon: true
              //     //       ? Image.asset('images/socialv/icons/ic_HeartFilled.png',
              //     //           height: 20, width: 22, fit: BoxFit.fill)
              //     //       : Image.asset('images/socialv/icons/ic_Heart.png',
              //     //           height: 24,
              //     //           width: 24,
              //     //           fit: BoxFit.cover,
              //     //           color: Colors.white),
              //     //   onPressed: () {
              //     //     //widget.story!.like = !widget.story!.like.validate();
              //     //     setState(() {});
              //     //   },
              //     // )
              //   ],
              // ),
            ],
          )),
    );
  }
}
