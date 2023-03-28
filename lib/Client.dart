import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import 'utils/SVCommon.dart';

class ServerClient with ChangeNotifier {
  late Socket socket;

  connectWithServer() async {
    try {
      // String ip = await getIp(context);
      String ipp = ip.split('/')[2];
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

  showNotification() {
    try {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              summary: 'Summary',
              title: 'Title',
              criticalAlert: true,
              body:
                  'bodysdffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdsdfsd',
              displayOnBackground: true,
              displayOnForeground: true,
              notificationLayout: NotificationLayout.MessagingGroup,
              bigPicture:
                  'https://cdn.pixabay.com/photo/2016/08/11/23/48/mountains-1587287__480.jpg'));
    } catch (e) {}
  }

  startListening() async {
    try {
      socket.write(loggedInUser!.CNIC);
      socket.listen((event) {
        var d = String.fromCharCodes(event);
        showNotification();
      });
    } catch (e) {}
  }
}
