import 'package:biit_social/models/User/UserModel.dart';
import 'package:biit_social/utils/IPHandleClass.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GetLikedByUsersScreen extends StatefulWidget {
  int postId;
  GetLikedByUsersScreen({super.key, required this.postId});

  @override
  State<GetLikedByUsersScreen> createState() => _GetLikedByUsersScreenState();
}

class _GetLikedByUsersScreenState extends State<GetLikedByUsersScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    users.clear();
    //getUsers();
  }

  List<User> users = [];
  getUsers() async {
    try {
      users.clear();
      var response = await Dio()
          .get('${IPHandle.ip}Reacts/getReactions?post_id=${widget.postId}');
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        for (var element in response.data) {
          users.add(User.fromMap(element));
        }
      }
    } catch (e) {}
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: getUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (users.isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    User u = users[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: sVProfileImageProvider(
                            IPHandle.profileimageAddress + u.profileImage,
                            40,
                            40),
                        title: Text(u.name ?? ''),
                        trailing: Image.asset(
                            'images/socialv/icons/ic_HeartFilled.png',
                            height: 20,
                            width: 22,
                            color: Colors.red,
                            fit: BoxFit.fill),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No likes'),
                );
              }
            } else {
              return getNotificationShimmer(context);
            }
          }),
    );
  }
}
