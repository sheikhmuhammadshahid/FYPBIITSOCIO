import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

import '../utils/IPHandleClass.dart';

var serverKey =
    'AAAAOdphUpY:APA91bG4pIrZBz8jSXlQIksRZ2wEqvrmw4KuI7W2aWIYPmLNVNw8VlHeCqN2wNqRFlrn1bP49TwmeLLPevgxhO8F9KnvhOnsG9UC9vJT5hTwIFLzo2A0Mic8FRj_sL6btkLQKq8B-R0_';
Future<void> sendNotification(String title, String body, cnic) async {
  try {
    var response =
        await Dio().get('${IPHandle.ip}User/getDeviceToken?cnic=$cnic');
    String token = response.data;
    if (response.statusCode == 200) {
      const postUrl = 'https://fcm.googleapis.com/fcm/send';
      final data1 = {
        "notification": {"body": body, "title": title, "sound": "default"},
        "priority": "high",
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "id": "1",
          "status": "done"
        },
        "to": token
      };

      final headers = {
        'content-type': 'application/json',
        'Authorization': 'key=$serverKey' //Replace with your server key
      };

      final response = await http.post(Uri.parse(postUrl),
          body: json.encode(data1),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);

      if (response.statusCode == 200) {
        // Notification sent successfully
        debugPrint("Notification sent");
      } else {
        // Notification sending failed
        debugPrint("Notification sending failed");
      }
    }
  } catch (e) {
    print(e);
  }
}
