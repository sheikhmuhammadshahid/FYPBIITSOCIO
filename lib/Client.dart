import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:signalr_client/signalr_client.dart';

import 'utils/SVCommon.dart';

class ServerClient with ChangeNotifier {
  late Socket socket;
  final hubConnection = HubConnectionBuilder()
      .withUrl('http://192.168.145.231/DevicesHub')
      .build();
  connectWithServer() async {
    try {
      // String ipp = ip.toString().split('/')[2];
      // socket = await Socket.connect(ipp, 5001);

      // startListening();
      var res = await Dio()
          .get("${ip}User/RegisterDevice?deviceId=${loggedInUser!.CNIC}");
      if (res.statusCode == 200) {
        await hubConnection.start();
        hubConnection.on('ReceiveMessage', (List<Object?> arguments) {
          final message = arguments[0];
          // Handle the message here
          EasyLoading.showToast(message.toString());
        });
      }
    } catch (e) {
      print(e);
    }
  }

  startListening() async {
    try {
      socket.write(loggedInUser!.CNIC);
      socket.listen((event) {
        var d = String.fromCharCodes(event);
        EasyLoading.showToast(d);
      });
    } catch (e) {}
  }
}
