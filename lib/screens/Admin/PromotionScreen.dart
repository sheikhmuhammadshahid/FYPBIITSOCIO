import 'package:biit_social/utils/SVCommon.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Controllers/SettingController.dart';
import 'package:provider/provider.dart';

import '../../utils/IPHandleClass.dart';
import '../../utils/SVConstants.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  @override
  Widget build(BuildContext context) {
    IPHandle.settingController = context.read<SettingController>();
    return Scaffold(
      appBar: AppBar(
        bottom: context.watch<SettingController>().isConnected
            ? null
            : PreferredSize(
                preferredSize: Size(context.width(), context.width() * 0.01),
                child: Container(
                  height: context.height() * 0.013,
                  width: context.width(),
                  color: Colors.red,
                  child: FittedBox(
                    child: Center(
                        child: Text(
                      'No internet connection!',
                      style: TextStyle(
                          fontFamily: svFontRoboto, color: Colors.white),
                    )),
                  ),
                )),
        title: Text(
          'Promote',
          style: TextStyle(color: context.iconColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
        child: Column(
          children: [
            DropdownButtonFormField(
              decoration: const InputDecoration(hintText: 'Select section'),
              items: const [],
              onChanged: (value) {},
            ),
            10.height,
            ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  title: const Text('Shahid'),
                  leading: sVProfileImageProvider('', 40, 40),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
