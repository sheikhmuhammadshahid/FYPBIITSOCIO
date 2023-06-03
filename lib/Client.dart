import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:biit_social/models/User/UserModel.dart';
import 'package:biit_social/utils/IPHandleClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'utils/SVCommon.dart';

class ServerClient with ChangeNotifier {
  late Socket socket;
  AppLifecycleState appLifecycleState = AppLifecycleState.resumed;
  connectWithServer() async {
    try {
      // String ip = await getIp(context);
      String ipp = IPHandle.ippp;
      print("connecting");
      socket = await Socket.connect(ipp, 5000);
      startListening();
      // Timer.periodic(const Duration(seconds: 30), (timer) async {
      //   var response = await Dio().get(
      //       '${IPHandle.ip}Chat/checkMessages?userId=${loggedInUser!.CNIC}');

      //   print(response.statusCode);
      //   print(response.data);
      //   if (response.statusCode == 200) {
      //     try {
      //       for (var element in response.data) {
      //         var chat = ChatModel.fromMap(element['chat']);
      //         var user = User.fromMap(element['sender']);
      //         showNotification(chat, user, false);
      //         //EasyLoading.dismiss();

      //         // EasyLoading.sh(chat.message);
      //       }
      //     } catch (e) {
      //       print(e);
      //     }
      //   }
      // });
    } catch (e) {
      print(e);
    }
  }

  sendMessage({message}) {
    try {
      socket.write(message);
    } catch (e) {}
  }

  showNotification(chat, User user, toshow) async {
    try {
      if (toshow) {
        EasyLoading.showToast(
          '${chat.message} online',
          toastPosition: EasyLoadingToastPosition.top,
        );
      } else {
        //IPHandle.playMessageGot();
        await AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'high_importance_channel',
                summary: 'Summary',
                title: user.name,
                criticalAlert: true,
                body: chat,
                displayOnBackground: true,
                displayOnForeground: true,
                notificationLayout: NotificationLayout.BigPicture,
                bigPicture: IPHandle.profileimageAddress + user.profileImage));
      }
    } catch (e) {}
  }

  dothis(event) async {
    try {
      var d = String.fromCharCodes(event);
      List<String> data = d.split('~').toList();

      if (data[0] == "-1") {
        // for (int i = 1; i < data.length - 1; i++) {
        // setstatus(data[i].trim(), true);
        String id = data[1].split(' ')[0].trim();
        print(id);
        var v = friendsStoriesController!.friends
            .where((element) =>
                element.CNIC.toLowerCase().trim() == id.toLowerCase().trim())
            .toList();
        print(v);
        if (v.isNotEmpty) {
          if (v[0].isOnline == null || v[0].isOnline == false) {
            //showNotification(v[0].name ?? v[0].CNIC, true);

            EasyLoading.showToast("${v[0].name ?? ''} online");
            v[0].isOnline = true;
          }
        }
      } else if (data[0] == "-2") {
        String id = data[1].split(' ')[0].trim();
        var v = friendsStoriesController!.friends
            .where((element) =>
                element.CNIC.toLowerCase().trim() == id.toLowerCase().trim())
            .toList();
        print(id);
        print(v);
        if (v.isNotEmpty) {
          v[0].isOnline = false;

          EasyLoading.showToast("${v[0].name ?? ''} offline");
        }
      } else {
        print(d);
        var sender = d.split('~')[1];
        print(sender);
        var res = friendsStoriesController!.friends
            .where((element) =>
                element.CNIC.toLowerCase().trim() ==
                sender.toLowerCase().trim())
            .toList();
        if (res.isNotEmpty) {
          await IPHandle.playMessageGot();
          showNotification(d.split('~')[3], res[0], false);
        } else {
          var res = friendsStoriesController!.groups
              .where((element) => element.id.toString().trim() == sender.trim())
              .toList();
          print(res);
          if (res.isNotEmpty) {
            showNotification(
                d.split('~')[3],
                User(
                    aridNo: "",
                    profileImage: res[0].profile,
                    password: '',
                    name: res[0].name,
                    CNIC: ''),
                false);
            print(res[0].isMuted);
            if (res[0].isMuted == false) {
              await IPHandle.playMessageGot();
            }
          }
        }
        // EasyLoading.showToast(d);
        //showNotification(d, false);
      }

      friendsStoriesController!.notifyListeners();
      Future.delayed(const Duration(seconds: 1)).then((value) async {});
    } catch (e) {}
  }

  startListening() async {
    try {
      socket.write('${loggedInUser!.CNIC}:${loggedInUser!.name ?? ''}');
      socket.listen((event) async {
        dothis(event);
      });
    } catch (e) {}
  }
}
