import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:biit_social/models/User/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../Controllers/SettingController.dart';
import '../../../utils/IPHandleClass.dart';

class SVGroupMembers extends StatefulWidget {
  const SVGroupMembers({super.key});

  @override
  State<SVGroupMembers> createState() => _SVAddMembersState();
}

class _SVAddMembersState extends State<SVGroupMembers> {
  @override
  Widget build(BuildContext context) {
    IPHandle.settingController = context.read<SettingController>();
    FriendsStoriesController friendsStoriesController =
        context.read<FriendsStoriesController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Group members',
          style: TextStyle(color: context.iconColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: friendsStoriesController.groupUsers.length,
            itemBuilder: (context, index) {
              User u = friendsStoriesController.groupUsers[index];
              return Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Card(
                  child: ListTile(
                      title: Text(u.name!),
                      subtitle: Text(
                        u.userType == "1"
                            ? u.aridNo
                            : u.userType == "2"
                                ? 'Teacher'
                                : 'Admin',
                      )),
                ),
              );
            }),
      ),
    );
  }
}
