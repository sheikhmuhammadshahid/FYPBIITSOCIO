import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:biit_social/models/SVGroupModel.dart';
import 'package:biit_social/screens/profile/screens/CreateGroup.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:provider/provider.dart';
import '../../Chat/ChatScreen.dart';
import '../../fragments/SVSearchFragment.dart';
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
    init();
  }

  late FriendsStoriesController friendsStoriesController;
  init() async {
    try {
      friendsStoriesController = context.read<FriendsStoriesController>();
      friendsStoriesController.getFriends();

      if (toShow!.toLowerCase().contains('gro')) {
        friendsStoriesController.getGroups();
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !toShow!.toLowerCase().contains('add')
          ? FloatingActionButton(
              backgroundColor: context.primaryColor,
              onPressed: () {
                toShow == 'Friends'
                    ? const SVSearchFragment().launch(context)
                    : const SvCreateGroupScreen().launch(context);
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
                onPressed: () {},
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
            DropdownButtonFormField(
              value: selectedDescipline,
              hint: const Text("Select Descipline"),
              items: desciplines.toList(),
              onChanged: (value) {
                selectedDescipline = value!;
                selected = true;
                getSections();
              },
            ),
            const SizedBox(
              height: 10,
            ),
            if (selected) ...{
              //  Selector(items: selectedSections, lable: "Section")
              TextFormField(
                decoration: const InputDecoration(hintText: 'Select Sections'),
                readOnly: true,
                onTap: () async {
                  await getSelector(
                      context, 'Select Sections', selectedSections);
                },
              ),
            },
            const SizedBox(
              height: 20,
            )
          },
          Consumer<FriendsStoriesController>(
            builder: (context, value, child) {
              return SizedBox(
                // flex: 4,
                height: !toShow!.toLowerCase().contains('add')
                    ? MediaQuery.of(context).size.height - 200
                    : MediaQuery.of(context).size.height,
                child: value.isStoriesLoading
                    ? svGetUserShimmer()
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: value.groups.length,
                        itemBuilder: (context, index) {
                          Group group = value.groups[index];

                          return group.name
                                  .toLowerCase()
                                  .contains(value.tofilter.toLowerCase())
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            groupChat: true,
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
                                              const SVGroupProfileScreen()
                                                  .launch(context);
                                            },
                                            child: group.profile == ''
                                                ? Image.asset(
                                                        group.isOfficial!
                                                            ? 'images/socialv/gifs/BIITLOGO.png'
                                                            : 'images/socialv/faces/face_2.png',
                                                        height: 52,
                                                        width: 52,
                                                        fit: BoxFit.cover)
                                                    .cornerRadiusWithClipRRect(
                                                        100)
                                                : Image.network(
                                                        profileimageAddress +
                                                            group.profile,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                    return Container(
                                                      color: Colors.black,
                                                      child: const Icon(
                                                          Icons.no_backpack),
                                                    );
                                                  },
                                                        height: 52,
                                                        width: 52,
                                                        fit: BoxFit.cover)
                                                    .cornerRadiusWithClipRRect(
                                                        100),
                                          ),
                                          title: Text(group.name),
                                          subtitle: Text(group.description == ''
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
              );
            },
          ),
        ]),
      ),
    );
  }
}
