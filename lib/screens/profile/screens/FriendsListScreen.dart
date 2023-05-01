import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:biit_social/utils/FilesPicker.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:provider/provider.dart';
import '../../../models/User/UserModel.dart';
import '../../Chat/ChatScreen.dart';
import '../../fragments/SVProfileFragment.dart';
import '../../fragments/SVSearchFragment.dart';

class FriendsListScreen extends StatefulWidget {
  String? toShow;
  FriendsListScreen({Key? key, required this.toShow}) : super(key: key);

  @override
  State<FriendsListScreen> createState() => _FriendsListScreenState(toShow);
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  // List<String> tabList = ['Topics', 'Replies', 'Engagement', 'Favourite'];

  int selectedTab = 0;
  String? toShow;
  _FriendsListScreenState(this.toShow);

  List<DropdownMenuItem> desciplines = [];

  List<Items> selectedSections = [];
  String? selectedDescipline;
  bool selected = false;

  getSections() {
    selectedSections = selectedDescipline != "All"
        ? friendsStoriesController.section
            .where((element) => element.name!
                .toLowerCase()
                .startsWith(selectedDescipline!.toLowerCase()))
            .toList()
        : friendsStoriesController.section;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  late FriendsStoriesController friendsStoriesController;
  init() async {
    try {
      friendsStoriesController = context.read<FriendsStoriesController>();
      friendsStoriesController.getFriends();
      friendsStoriesController.getSectionAndDesciplines();
    } catch (e) {}
  }

  List<String> selectedUsers = [];
  @override
  Widget build(BuildContext context) {
    friendsStoriesController = context.read<FriendsStoriesController>();
    return Scaffold(
      floatingActionButton: !toShow!.toLowerCase().contains('add')
          ? FloatingActionButton(
              backgroundColor: context.primaryColor,
              onPressed: () {
                const SVSearchFragment().launch(context);
              },
              child: Icon(
                Icons.add,
                color: context.scaffoldBackgroundColor,
              ))
          : null,
      backgroundColor: svGetScaffoldColor(),
      appBar: AppBar(
        backgroundColor: svGetScaffoldColor(),
        iconTheme: IconThemeData(color: context.iconColor),
        title: Text('${widget.toShow}', style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        actions: [
          if (toShow!.toLowerCase().contains('add'))
            TextButton(
                onPressed: () async {
                  await friendsStoriesController.createGroup(selectedUsers);
                  path = null;
                },
                child: Text(
                  'Create',
                  style: boldTextStyle(size: 16),
                )),
          //IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        ],
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 100),
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: context.cardColor, borderRadius: radius(8)),
            child: AppTextField(
              onFieldSubmitted: (p0) {
                friendsStoriesController.tofilter = p0;
                friendsStoriesController.notifyListeners();
              },
              onChanged: (p0) {
                friendsStoriesController.tofilter = p0;
                friendsStoriesController.notifyListeners();
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
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          if (toShow!.toLowerCase().contains('add')) ...{
            Consumer<FriendsStoriesController>(
              builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: value.isStoriesLoading
                      ? svGetUserShimmer()
                      : Column(
                          children: [
                            DropdownButtonFormField(
                              value: selectedDescipline,
                              hint: const Text("Select Descipline"),
                              items: friendsStoriesController.desciplines,
                              onChanged: (value) {
                                selectedDescipline = value!;
                                selected = true;
                                getSections();
                              },
                            ),
                            const SizedBox(
                              height: 20,
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
                                },
                              ),
                            },
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                );
              },
            )
          },
          Consumer<FriendsStoriesController>(
            builder: (context, value, child) {
              return SizedBox(
                // flex: 4,
                height: !toShow!.toLowerCase().contains('add')
                    ? MediaQuery.of(context).size.height - 200
                    : MediaQuery.of(context).size.height,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: value.friends.length,
                  itemBuilder: (context, index) {
                    User user = value.friends[index];

                    return user.name!
                            .toLowerCase()
                            .contains(value.tofilter.toLowerCase())
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      groupChat: false,
                                      id: user.CNIC,
                                      profileScreen: user.profileImage,
                                      name: user.name == null ? '' : user.name!,
                                      section: user.section == null
                                          ? ''
                                          : user.section!,
                                    ),
                                  ));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SVProfileFragment(
                                                user: false,
                                                id: user.CNIC,
                                              ),
                                            ));
                                      },
                                      child: user.profileImage == ''
                                          ? Image.asset(
                                                  'images/socialv/faces/face_2.png',
                                                  height: 52,
                                                  width: 52,
                                                  fit: BoxFit.cover)
                                              .cornerRadiusWithClipRRect(100)
                                          : Image.network(
                                                  profileimageAddress +
                                                      user.profileImage,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                              return Container(
                                                color: Colors.black,
                                                child: const Icon(
                                                    Icons.no_backpack),
                                              );
                                            },
                                                  height: 52,
                                                  width: 52,
                                                  fit: BoxFit.cover)
                                              .cornerRadiusWithClipRRect(100),
                                    ),
                                    title: widget.toShow == 'Groups'
                                        ? const Text('Group Name')
                                        : Text(value.friends[index].name ?? ''),
                                    subtitle: Text(user.userType == "2"
                                        ? "Teacher"
                                        : user.userType == "3"
                                            ? user.section ?? '---'
                                            : 'Admin'),
                                    trailing: toShow!
                                            .toLowerCase()
                                            .contains('add')
                                        ? Checkbox(
                                            onChanged: (val) {
                                              try {
                                                if (val!) {
                                                  selectedUsers.add(user.CNIC);
                                                } else {
                                                  selectedUsers
                                                      .remove(user.CNIC);
                                                }
                                                setState(() {});
                                              } catch (e) {}
                                            },
                                            value: selectedUsers.any(
                                                (element) =>
                                                    element.trim() ==
                                                    user.CNIC.trim()))
                                        : onlineUserIcon(
                                            user.isOnline ?? false),
                                  ),
                                  const Divider(
                                    thickness: 1,
                                  )
                                ],
                              ),
                            ))
                        : const SizedBox.shrink();
                  },
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}
