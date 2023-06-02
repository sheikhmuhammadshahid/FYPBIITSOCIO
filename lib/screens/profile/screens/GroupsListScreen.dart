import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:biit_social/models/SVGroupModel.dart';
import 'package:biit_social/screens/profile/screens/CreateGroup.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:provider/provider.dart';
import '../../../Controllers/SettingController.dart';
import '../../../utils/IPHandleClass.dart';
import '../../Chat/ChatScreen.dart';
import 'SVGroupProfileScreen.dart';

class GroupsListScreen extends StatefulWidget {
  String? toShow;
  GroupsListScreen({Key? key, required this.toShow}) : super(key: key);

  @override
  State<GroupsListScreen> createState() => _GroupsListScreenState(toShow);
}

class _GroupsListScreenState extends State<GroupsListScreen> {
  // List<String> tabList = ['Topics', 'Replies', 'Engagement', 'Favourite'];

  int selectedTab = 0;
  String? toShow;
  _GroupsListScreenState(this.toShow);

  var desciplines = [
    const DropdownMenuItem(value: "All", child: Text("All")),
    const DropdownMenuItem(value: "BSIT", child: Text("BSIT")),
    const DropdownMenuItem(value: "BSCS", child: Text("BSCS")),
    const DropdownMenuItem(value: "BSSE", child: Text("BSSE")),
    const DropdownMenuItem(value: "BSAI", child: Text("BSAI")),
  ];
  List<Items> sections = [
    Items(id: 28, name: "All"),
    Items(id: 1, name: "BSCS-7C"),
    Items(id: 3, name: "BSCS-5B"),
    Items(id: 4, name: "BSCS-7A"),
    Items(id: 5, name: "BSIT-7A"),
    Items(id: 6, name: "BSIT-2A"),
    Items(id: 7, name: "BSCS-6A"),
  ];
  List<Items> selectedSections = [];
  String? selectedDescipline;
  bool selected = false;
  getSections() {
    selectedSections = selectedDescipline != "All"
        ? sections
            .where((element) =>
                element.id == 28 ||
                element.name!
                    .toLowerCase()
                    .startsWith(selectedDescipline!.toLowerCase()))
            .toList()
        : sections;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    IPHandle.settingController = context.read<SettingController>();
    //init();
  }

  late FriendsStoriesController friendsStoriesController;
  init() async {
    try {
      // friendsStoriesController = context.read<FriendsStoriesController>();

      await friendsStoriesController.getGroups();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    friendsStoriesController = context.read<FriendsStoriesController>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: context.primaryColor,
          onPressed: () {
            const SvCreateGroupScreen().launch(context);
          },
          child: Icon(
            Icons.add,
            color: context.scaffoldBackgroundColor,
          )),
      backgroundColor: svGetScaffoldColor(),
      appBar: AppBar(
        backgroundColor: svGetScaffoldColor(),
        iconTheme: IconThemeData(color: context.iconColor),
        title: Text('${widget.toShow}', style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        actions: const [
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
          SizedBox(
              // flex: 4,
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder(
                future: init(),
                builder: (context, snapshot) => friendsStoriesController
                        .isStoriesLoading
                    ? getNotificationShimmer(context)
                    : friendsStoriesController.groups.isEmpty
                        ? Center(
                            child: Text(
                              'No groups found!',
                              style: TextStyle(
                                  color: context.iconColor,
                                  fontFamily: fontFamilySecondaryGlobal),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: friendsStoriesController.groups.length,
                            itemBuilder: (context, index) {
                              Group group =
                                  friendsStoriesController.groups[index];

                              return group.name.toLowerCase().contains(
                                      friendsStoriesController.tofilter
                                          .toLowerCase())
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChatScreen(
                                                groupChat: true,
                                                group: group,
                                                id: group.id.toString(),
                                                profileScreen: group.profile,
                                                name: group.name,
                                                section: group.description,
                                              ),
                                            ));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              leading: GestureDetector(
                                                onTap: () {
                                                  SVGroupProfileScreen(
                                                    group: group,
                                                  ).launch(context);
                                                },
                                                child: group.profile == ''
                                                    ? Image.asset(
                                                            group.isOfficial!
                                                                ? 'images/socialv/gifs/BIITLOGO.png'
                                                                : 'images/socialv/faces/face_5.png',
                                                            height: 52,
                                                            width: 52,
                                                            fit: BoxFit.cover)
                                                        .cornerRadiusWithClipRRect(
                                                            100)
                                                    : Image.network(
                                                            IPHandle.profileimageAddress +
                                                                group.profile,
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                        return Container(
                                                          color: Colors.black,
                                                          child: const Icon(
                                                              Icons
                                                                  .no_backpack),
                                                        );
                                                      },
                                                            height: 52,
                                                            width: 52,
                                                            fit: BoxFit.cover)
                                                        .cornerRadiusWithClipRRect(
                                                            100),
                                              ),
                                              title: Text(group.name),
                                              subtitle:
                                                  Text(group.description == ''
                                                      ? group.isOfficial!
                                                          ? 'Official group'
                                                          : 'non Official'
                                                      : group.description),
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
              ))
        ]),
      ),
    );
  }
}
