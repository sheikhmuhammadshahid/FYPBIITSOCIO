import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

Widget getChatWidget(String text, userItself) {
  return SizedBox(
    child: ListTile(
      leading: Image.asset('images/socialv/faces/face_2.png',
              height: 52, width: 52, fit: BoxFit.cover)
          .cornerRadiusWithClipRRect(100),
      title: Text(text),
      subtitle: const Text('CS7A'),
    ),
  );
}
