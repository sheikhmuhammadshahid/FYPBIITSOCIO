import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
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
      socket = await Socket.connect(ipp, 5000);
      startListening();
    } catch (e) {
      print(e);
    }
  }

  sendMessage({message}) {
    try {
      socket.write(message);
    } catch (e) {}
  }

  showNotification(message, toshow) {
    try {
      if (toshow) {
        EasyLoading.showToast(
          message + ' online',
          toastPosition: EasyLoadingToastPosition.top,
        );
      } else {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'basic_channel',
                summary: 'Summary',
                title: 'Title',
                criticalAlert: true,
                body: message + ' online',
                displayOnBackground: true,
                displayOnForeground: true,
                notificationLayout: NotificationLayout.Default,
                bigPicture:
                    'https://cdn.pixabay.com/photo/2016/08/11/23/48/mountains-1587287__480.jpg'));
      }
    } catch (e) {}
  }

  startListening() async {
    try {
      socket.write('${loggedInUser!.CNIC}:${loggedInUser!.name ?? ''}');
      socket.listen((event) {
        var d = String.fromCharCodes(event);
        List<String> data = d.split('~').toList();

        if (data[0] == "-1") {
          for (int i = 1; i < data.length - 1; i++) {
            // setstatus(data[i].trim(), true);
            String id = data[i];
            var v = friendsStoriesController!.friends
                .where((element) => element.CNIC == id.trim())
                .toList();
            if (v.isNotEmpty) {
              if (v[0].isOnline == null || v[0].isOnline == false) {
                showNotification(v[0].name ?? v[0].CNIC, true);

                v[0].isOnline = true;
              }
            }
          }
        } else if (data[0] == "-2") {
          String id = data[1].trim();
          var v = friendsStoriesController!.friends
              .where((element) => element.CNIC == id.trim())
              .toList();
          if (v.isNotEmpty) {
            v[0].isOnline = false;
          }
        } else {
          showNotification(d, false);
        }

        friendsStoriesController!.notifyListeners();
      });
    } catch (e) {}
  }
}
