import 'dart:convert';

import 'package:biit_social/Client.dart';
import 'package:biit_social/Controllers/SettingController.dart';
import 'package:biit_social/models/FriendRequesModel.dart';
import 'package:biit_social/models/Stories/Societies.dart';
import 'package:biit_social/models/Stories/Stories.dart';
import 'package:biit_social/screens/Chat/ChatModel/ChatModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../models/SVCommentModel.dart';
import '../models/SVGroupModel.dart';
import '../models/SVNotificationModel.dart';
import '../models/User/UserModel.dart';
import '../utils/SVCommon.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FriendsStoriesController extends ChangeNotifier {
  bool isCLicked = false;
  int selectedIndex = -1;
  TextEditingController filterController = TextEditingController();
  bool isStoriesLoading = true;
  bool storiesLoading = true;
  Duration duration = const Duration(seconds: 3);
  List<Society> societies = [];
  List<User> groupUsers = [];
  List<SVCommentModel> comments = [];
  List<ChatModel> chats = [];
  List<Items> section = [];
  List<DropdownMenuItem> desciplines = [];
  List<Group> groups = [];
  List<User> friends = [];
  String tofilter = '';
  late Group group;
  // filterFriends(text) {
  //   try {
  //     friendsToShow = friends
  //         .where((element) => element.name!
  //             .toLowerCase()
  //             .contains(text.toString().toLowerCase()))
  //         .toList();
  //     notifyListeners();
  //   } catch (e) {}
  // }

  List<Stories> stories = [];
  int indexShownStory = -1;
  int index = 0;
  shownIncrent() {
    if (indexShownStory <= societies[index].stories!.length - 1) {
      indexShownStory++;
    }
    notifyListeners();
  }

  increment() {
    if (index <= societies.length - 1) {
      indexShownStory = -1;
      index++;
    }
    notifyListeners();
  }

  sendFriendReques(to, context) async {
    try {
      FriendRequest f = FriendRequest(
          id: int.parse(loggedInUser!.userType!),
          RequestedBy: loggedInUser!.CNIC,
          RequestedTo: to,
          status: 'pending');
      var response = await Dio().post('${ip}Friends/sendFriendRequest',
          data: f.toJson(), options: Options(headers: headers));
      if (response.statusCode == 200) {
        getSnackBar(
          context: context,
          message: response.data,
        );
        return true;
      } else {
        getSnackBar(context: context, message: response.data);
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  acceptFriendReques({to, context, status, not_id}) async {
    try {
      var response = await Dio().get(
        '${ip}Friends/acceptFriendRequest?reques_id=$to&&status=$status&&noti_id=$not_id',
      );
      getSnackBar(context: context, message: response.data);
    } catch (e) {}
  }

  unFriend({to, context}) async {
    try {
      var response = await Dio().get(
        '${ip}Friends/unfriend?sentBy=${loggedInUser!.CNIC}&&sentTo=$to',
      );
      getSnackBar(context: context, message: response.data);
      return true;
    } catch (e) {}
    return false;
  }

  List<SVNotificationModel> listToday = [];
  List<SVNotificationModel> listMonth = []; // = getNotificationsThisMonth();
  List<SVNotificationModel> listEarlier = [];
  List<SVNotificationModel> notifications = [];
  getNotifications(context) async {
    try {
      isStoriesLoading = true;
      var controller = Provider.of<SettingController>(context, listen: false);
      var response = await Dio().get(
          "${ip}Notification/getNotification?userId=${loggedInUser!.CNIC}&fromWall=${controller.selectedWall}");
      if (response.statusCode == 200) {
        notifications.clear();
        listEarlier.clear();
        listMonth.clear();
        listToday.clear();

        for (var element in response.data) {
          try {
            var v = SVNotificationModel.fromMap(element["n"]);
            v.name = element["user"]["name"] ?? "";
            v.profileImage = element["user"]["profileImage"] ?? "";
            v.postImage = element["postImage"] ?? "";
            notifications.add(v);
          } catch (e) {}
        }

        for (var e in notifications) {
          String res = getDateStatus(e.dateTime!);
          if (res == "Today") {
            listToday.add(e);
          } else if (res == "month") {
            listMonth.add(e);
          } else {
            listEarlier.add(e);
          }
        }
      }
    } catch (e) {
      print(e);
    }
    isStoriesLoading = false;

    setState();
  }

  String getDateStatus(String dateString) {
    try {
      DateTime date = DateFormat("MM/dd/yyyy").parse(dateString);
      DateTime today = DateTime.now();
      DateTime startOfMonth = DateTime(today.year, today.month, 1);

      if (date.year == today.year &&
          date.month == today.month &&
          date.day == today.day) {
        return "Today";
      } else if (date.year == today.year && date.month == today.month) {
        return "month";
      } else {
        return "Earlier";
      }
    } catch (e) {}
    return "";
  }

  getSocietiesDetail() async {
    try {
      storiesLoading = true;
      setState();

      var response = await Dio().get('${ip}Post/getSocietiesDetail?cnic=${loggedInUser!.CNIC}');
      if (response.statusCode == 200) {
        societies.clear();
        for (var element in response.data) {
          societies.add(Society.fromMap(element));
        }
        print("${societies.length}sdsd");
      }
    } catch (e) {}
    print('done');
    storiesLoading = false;

    setState();
  }

  setState() {
    try {
      notifyListeners();
    } catch (e) {}
  }

  bool isSectionsLoading = true;
  getSectionAndDesciplines() async {
    try {
      var response =
          await Dio().get('${ip}user/getDescipline?cnic=${loggedInUser!.CNIC}');
      isSectionsLoading = true;
      setState();
      if (response.statusCode == 200) {
        section.clear();
        desciplines.clear();
        int i = 1;
        desciplines.add(
          const DropdownMenuItem(value: 'All', child: Text("All")),
        );
        print('sections');
        print(response.data['sections']);
        section.add(Items(name: 'All', id: 0));
        for (var element in response.data['sections']) {
          if (element != '' && element != null) {
            section.add(Items(name: element, id: i));
          }
          i++;
        }
        i = 1;
        print('diinm');
        print(response.data['desciplines']);
        for (var element in response.data['desciplines']) {
          desciplines.add(
            DropdownMenuItem(value: element, child: Text(element)),
          );
        }
      }
    } catch (e) {}
    isSectionsLoading = false;

    setState();
  }

  getSections(String selectedDescipline) {
    List<Items> items = [];
    try {
      items.add(Items(id: section.length + 1, name: 'All'));
      var v = selectedDescipline != "All"
          ? selectedDescipline != "Parents" &&
                  selectedDescipline != "Students" &&
                  selectedDescipline != "Teachers" &&
                  selectedDescipline != "Courses" &&
                  selectedDescipline != 'Friends'
              ? section
                  .where((element) => element.name!
                      .toLowerCase()
                      .startsWith(selectedDescipline.toLowerCase()))
                  .toList()
              : selectedDescipline == "Teachers"
                  ? section
                      .where((element) => element.name!.split('!').length == 1
                          ? false
                          : element.name!.split('!')[1].trim() == "2")
                      .toList()
                  : selectedDescipline == "Students"
                      ? section
                          .where((element) => element.name!.split('!').length == 1
                              ? false
                              : element.name!.split('!')[1].trim() == "1")
                          .toList()
                      : selectedDescipline == "Friends"
                          ? section
                              .where((element) => element.name!.split('!').length == 1
                                  ? false
                                  : element.name!.split('!')[1].trim() == "f")
                              .toList()
                          : selectedDescipline == "Courses"
                              ? section
                                  .where((element) =>
                                      element.name!.split('!').length == 1
                                          ? false
                                          : element.name!.split('!')[1].trim() ==
                                              "co")
                                  .toList()
                              : selectedDescipline == "Admin"
                                  ? section
                                      .where((element) =>
                                          element.name!.split('!').length == 1
                                              ? false
                                              : element.name!.split('!')[1].trim() ==
                                                  "3")
                                      .toList()
                                  : section
                                      .where((element) => element.name!.split('!').length == 1 ? false : element.name!.split('!')[1].trim() == "4")
                                      .toList()
          : section;
      for (int i = 0; i < v.length; i++) {
        if (v[i].name!.split('!').length > 1) {
          v[i].name = v[i].name!.split('!')[0];
        }
      }

      items.addAll(v);
    } catch (e) {
      print(e);
    }
    return items;
  }

  getChats(id, fromGroup) async {
    try {
      isStoriesLoading = true;
      setState();
      String url = '';
      if (fromGroup) {
        url =
            '${ip}groups/getChatOfGroup?id=$id&loggedInUserId=${loggedInUser!.CNIC}';
      } else {
        url =
            '${ip}chat/getChat?loggedInUserId=${loggedInUser!.CNIC}&chatwithId=$id';
      }
      var response = await Dio().get(url);
      if (response.statusCode == 200) {
        chats.clear();
        for (var element in response.data) {
          chats.add(ChatModel.fromMap(element));
        }
      }
    } catch (e) {}
    isStoriesLoading = false;
    notifyListeners();
  }

  sendChat(ChatModel ch, ServerClient client, fromGroup) async {
    try {
      String chatId = ch.senderImage;
      ch.senderImage = loggedInUser!.profileImage;
      chats.add(ch);
      notifyListeners();
      var data = FormData.fromMap({
        'userid': loggedInUser!.CNIC,
        'chat_id': chatId,
        'dateTime': DateTime.now().toString(),
        'text': ch.message,
        'image': ch.type == "image" || ch.type == "video"
            ? await MultipartFile.fromFile(ch.url!)
            : null,
        'type': ch.type
      });
      var response = await Dio().post('${ip}chat/addChat',
          data: data, options: Options(headers: headers));
      if (response.statusCode == 200) {
        //EasyLoading.showToast('added');
        if (fromGroup) {
          client.sendMessage(
              message: '${loggedInUser!.CNIC}~${ch.senderImage}~${ch.message}');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  getFriends() async {
    try {
      isStoriesLoading = true;
      setState();
      var response = await Dio()
          .get('${ip}Friends/getFriends?user_id=${loggedInUser!.CNIC}');
      if (response.statusCode == 200) {
        friends.clear();
        for (var element in response.data) {
          User u = User.fromMap(element);
          if (friends.where((element) => element.CNIC == u.CNIC).isEmpty) {
            friends.add(u);
          }
        }
      }
    } catch (e) {}
    isStoriesLoading = false;
    setState();
  }

  getGroups() async {
    try {
      isStoriesLoading = true;
      setState();
      var res = await Dio().get(
          '${ip}groups/getGroups?cnic=${loggedInUser!.CNIC}&userType=${loggedInUser!.userType}');
      if (res.statusCode == 200) {
        groups.clear();
        for (var element in res.data) {
          groups.add(Group.fromMap(element));
        }
      }
    } catch (e) {}
    isStoriesLoading = false;
    setState();
  }

  createGroup(List<String> users) async {
    try {
      var d = users.join(',');
      print(d);
      var body = FormData.fromMap({
        'Admin': group.Admin,
        'description': group.description,
        'name': group.name,
        'profile': group.profile != ''
            ? await MultipartFile.fromFile(group.profile)
            : null,
        'isOfficial': group.isOfficial,
        'memberCount': users.length,
        'users': users
      });
      print(body);
      var response = await Dio().post('${ip}Groups/addGroup',
          data: body, options: Options(headers: headers));
      if (response.statusCode == 200) {
        EasyLoading.showToast(response.data['message']);

        // groups.add(response.data);
      }
    } catch (e) {
      EasyLoading.showToast('Server not responding!');
    }
  }

  getComments(postId) async {
    try {
      isCLicked = false;
      isStoriesLoading = true;
      comments.clear();
      setState();
      var response =
          await Dio().get('${ip}comments/getComment?post_id=$postId');
      if (response.statusCode == 200) {
        for (var element in response.data) {
          comments.add(SVCommentModel.fromMap(element));
        }
      }
    } catch (e) {}
    isStoriesLoading = false;
    setState();
  }

  getGroupDetail(int id) async {
    try {
      isStoriesLoading = true;
      groupUsers.clear();
      setState();

      var response = await Dio().get('${ip}Groups/getGroupDetail?id=$id');
      if (response.statusCode == 200) {
        for (var element in response.data) {
          groupUsers.add(User.fromMap(element));
        }
      }
    } catch (e) {
      print(e);
    }
    print(groupUsers);
    isStoriesLoading = false;
    setState();
  }

  addComment(postId, repLiedOn) async {
    try {
      var v = comments.last;
      var data = jsonEncode({
        'userId': loggedInUser!.CNIC,
        'postId': postId,
        'dateTime': v.time,
        'repliedOn': repLiedOn,
        'text': v.comment,
      });
      var response = await Dio().post('${ip}comments/addComment',
          data: data, options: Options(headers: headers));
      if (response.statusCode == 200) {
        EasyLoading.showToast('commented successfully');
      }
    } catch (e) {}
  }
}
