import 'dart:io';

import 'package:biit_social/Controllers/PostController.dart';
import 'package:biit_social/models/Post/PostModel.dart';
import 'package:biit_social/models/Stories/Stories.dart';
import 'package:biit_social/screens/FileUpload/UploadFile.dart';
import 'package:biit_social/utils/getVideoItem.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/main.dart';
import 'package:biit_social/screens/addPost/components/SVPostTextComponent.dart';
import 'package:biit_social/utils/SVColors.dart';
import 'package:biit_social/utils/SVCommon.dart';
import '../../Controllers/FriendsStoriesController.dart';
import '../../utils/FilesPicker.dart';
import '../../utils/SVConstants.dart';
import 'package:provider/provider.dart';

class SVAddPostFragment extends StatefulWidget {
  bool isStatus = false;
  SVAddPostFragment({Key? key, required this.isStatus}) : super(key: key);
  static var assetEntity;
  static bool? isImage = true;
  @override
  State<SVAddPostFragment> createState() => _SVAddPostFragmentState();
}

class _SVAddPostFragmentState extends State<SVAddPostFragment> {
  String image = '';
  @override
  void initState() {
    super.initState();

    afterBuildCreated(() {
      setStatusBarColor(context.cardColor);
    });
    context.read<FriendsStoriesController>().getSectionAndDesciplines();
  }

  @override
  void dispose() {
    setStatusBarColor(
        appStore.isDarkMode ? appBackgroundColorDark : SVAppLayoutBackground);
    super.dispose();
  }

  var desciplines = [
    const DropdownMenuItem(value: "All", child: Text("All")),
    const DropdownMenuItem(value: "BSIT", child: Text("BSIT")),
    const DropdownMenuItem(value: "BSCS", child: Text("BSCS")),
    const DropdownMenuItem(value: "BSSE", child: Text("BSSE")),
    const DropdownMenuItem(value: "BSAI", child: Text("BSAI")),
    const DropdownMenuItem(value: "1", child: Text("Students")),
    const DropdownMenuItem(value: "2", child: Text("Teachers")),
    const DropdownMenuItem(value: "3", child: Text("Admin")),
  ];

  List<Items> selectedSections = [];
  String? selectedDescipline;
  late FriendsStoriesController friendStoriesController;
  bool selected = false;
  TextEditingController descriptionController = TextEditingController();
  late PostController postController;
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    friendStoriesController = context.read<FriendsStoriesController>();
    postController = context.read<PostController>();
    return Scaffold(
      backgroundColor: context.cardColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.iconColor),
        backgroundColor: context.cardColor,
        title: Text('New Post', style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: false,
        actions: [
          if (loggedInUser!.userType == "2" ||
              loggedInUser!.userType == "3") ...{
            IconButton(
              onPressed: () {
                setState(() {
                  clicked = !clicked;
                });
              },
              icon: const Icon(Icons.supervised_user_circle_sharp),
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const UploadFile();
                    },
                  ));
                },
                icon: const Icon(Icons.calendar_month)),
          },
          AppButton(
            shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
            text: 'Post',
            textStyle: secondaryTextStyle(color: Colors.white, size: 10),
            onTap: () async {
              !widget.isStatus
                  ? PostController().addPost(
                      Post(
                          fromWall: loggedInUser!.userType!,
                          description: descriptionController.text,
                          user: loggedInUser!.toJson().toString(),
                          postFor: selectedOptions,
                          dateTime: DateTime.now().toString(),
                          type: isImagePicked == 1
                              ? "image"
                              : isImagePicked == 2
                                  ? 'video'
                                  : "text",
                          text: isImagePicked != 0 ? path.path : "",
                          postedBy: loggedInUser!.CNIC),
                      context)
                  : PostController().addStory(
                      Stories(
                        id: 0,
                        societyId: 3,
                        type: isImagePicked == 1
                            ? "image"
                            : isImagePicked == 2
                                ? 'video'
                                : "text",
                        url: "",
                        text: descriptionController.text,
                      ),
                      context);
            },
            elevation: 0,
            color: SVAppColorPrimary,
            width: 50,
            padding: const EdgeInsets.all(0),
          ).paddingAll(16),
        ],
      ),
      body: SizedBox(
        height: context.height(),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SVPostTextComponent(controller: descriptionController),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        children: [
                          if (!clicked)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                color: Colors.black,
                                height:
                                    MediaQuery.of(context).size.height / 2 - 50,
                                width: MediaQuery.of(context).size.width,
                                child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return isImagePicked != 0
                                        ? isImagePicked == 1
                                            ? Image.file(
                                                File(path.path),
                                                fit: BoxFit.fill,
                                              )
                                            : GetVideoItem(
                                                url: path.path,
                                                fromNetwork: false)
                                        : Image.asset(
                                            'images/socialv/posts/post_one.png');
                                  },
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          !context
                                  .watch<FriendsStoriesController>()
                                  .isSectionsLoading
                              ? DropdownButtonFormField(
                                  value: selectedDescipline,
                                  hint: const Text("Select Descipline"),
                                  items: friendStoriesController.desciplines,
                                  onChanged: (value) {
                                    selectedDescipline = value!;
                                    selected = true;
                                    selectedSections = friendStoriesController
                                        .getSections(selectedDescipline!);
                                    print(selectedSections);
                                    setState(() {});
                                  },
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 10,
                          ),
                          if (selected) ...{
                            //  Selector(items: selectedSections, lable: "Section")
                            TextFormField(
                              decoration: const InputDecoration(
                                  hintText: 'Select Sections'),
                              readOnly: true,
                              onTap: () async {
                                await getSelector(context, 'Select Sections',
                                    selectedSections);
                                setState(() {});
                              },
                            )
                          },
                          if (selected) ...{
                            const SizedBox(
                              height: 10,
                            ),
                            //  Selector(items: selectedSections, lable: "Section")
                            Wrap(
                              children: [
                                for (int i = 0; i < selecteds.length; i++) ...{
                                  Chip(label: Text(selecteds[i]))
                                }
                              ],
                            )
                          }
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: getBottom(),
            ),
          ],
        ),
      ),
    );
  }

  getBottom() {
    return Container(
      width: context.width(),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: svGetScaffoldColor(),
        borderRadius: radiusOnly(
            topRight: SVAppContainerRadius, topLeft: SVAppContainerRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: (() async {
                    // postController
                    //     .controller.flickVideoManager!.videoPlayerController!
                    //     .pause();
                    await pickFile(context, 0);
                    setState(() {});
                  }),
                  child: Image.asset('images/socialv/icons/ic_CameraPost.png',
                      height: 30, width: 30, fit: BoxFit.cover),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: (() async {
                    // postController
                    //     .controller.flickVideoManager!.videoPlayerController!
                    //     .pause();
                    await pickFile(context, 0);
                    setState(() {});
                  }),
                  child: Text("click here to choose...",
                      style: secondaryTextStyle(
                        size: 15,
                        color: svGetBodyColor(),
                      )),
                )
                // HorizontalList(
                //   itemCount: list.length,
                //   itemBuilder: (context, index) {
                //     return Image.asset(list[index],
                //         height: 62, width: 52, fit: BoxFit.cover);
                //   },
                // )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          )
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Image.asset('images/socialv/icons/ic_Video.png',
          //         height: 32, width: 32, fit: BoxFit.cover),
          //     //Image.asset('images/socialv/icons/ic_CameraPost.png', height: 32, width: 32, fit: BoxFit.cover),
          //     Image.asset('images/socialv/icons/ic_Voice.png',
          //         height: 32, width: 32, fit: BoxFit.cover),
          //     Image.asset('images/socialv/icons/ic_Location.png',
          //         height: 32, width: 32, fit: BoxFit.cover),
          //     Image.asset('images/socialv/icons/ic_Paper.png',
          //         height: 32, width: 32, fit: BoxFit.cover),
          //   ],
          // ),
        ],
      ),
    );
  }

  // final List<Items> _selectedAnimals2 = [];
  // List<Items> _selectedAnimals3 = [];
  // //List<Animal> _selectedAnimals4 = [];
  // final List<Items> _selectedAnimals5 = [];
  // final _multiSelectKey = GlobalKey<FormFieldState>();
  // _showMultiSelect(BuildContext context, lable, items) async {
  //   return await showModalBottomSheet(
  //     isScrollControlled: true, // required for min/max child size
  //     context: context,
  //     builder: (ctx) {
  //       return MultiSelectBottomSheet<Items>(
  //         listType: MultiSelectListType.LIST,
  //         initialChildSize: 0.7,
  //         maxChildSize: 0.95,
  //         title: const Text("Sections"),
  //         //  buttonText: Text(lable),
  //         items: items,
  //         searchable: true,
  //         // validator: (values) {
  //         //   if (values == null || values.isEmpty) {
  //         //     return "Required";
  //         //   }
  //         //   List<String> names = values.map((e) => e.name!).toList();
  //         //   if (names.contains("All")) {
  //         //     return "Will be available for all Semesters!";
  //         //   }
  //         //   return null;
  //         // },
  //         onConfirm: (values) {
  //           setState(() {
  //             _selectedAnimals3 = values;
  //           });
  //           _multiSelectKey.currentState!.validate();
  //         },
  //         // // chipDisplay: MultiSelectChipDisplay<Items>(
  //         // //   items: items
  //         // //       .map((animal) => MultiSelectItem<Items>(animal, animal.name!))
  //         // //       .toList(),
  //         // //   onTap: (item) {
  //         // //     setState(() {
  //         // //       _selectedAnimals3.remove(item);
  //         // //     });
  //         // //     print('here');
  //         // //     _multiSelectKey.currentState!.validate();
  //         // //     return _selectedAnimals3;
  //         // //   },
  //         // ),
  //       );
  //     },
  //   );
  // }
}
