import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../models/Post/PostModel.dart';
import '../utils/IPHandleClass.dart';
import '../utils/SVCommon.dart';

class HistoryController {
  static savePosts() async {
    try {
      String url =
          "${IPHandle.ip}post/getPostsForHistory?userCnic=${loggedInUser!.CNIC}&lastSavedPostId=1";
      //var v = jsonEncode(post.toMap());

      print(url);

      Box postsBox = Hive.box('Posts');
      var response = await Dio().get(url);
      //body: post.toJson(), headers: headers);
      if (response.statusCode == 200) {
        postsBox.clear();
        var data = response.data;
        for (var element in data) {
          Post p = Post.fromMap(element["post"]);
          p.isFriend = element["isFriend"];
          p.isLiked = element["isLiked"];
          p.isPinned = element["isPinned"];
          await postsBox.add(p.toMap());
        }
      }
      print("PostBox${postsBox.length}");
    } catch (e) {
      print(e);
    }
  }

  static saveChats() async {
    try {} catch (e) {}
  }

  static Future<List<Post>> getPosts(String fromWall) async {
    List<Post> posts = [];
    try {
      Box postsBox = Hive.box('Posts');
      var data = postsBox.values
          .where((element) => element['fromWall'] == fromWall)
          .toList();
      print(data.length);
      for (var element in data) {
        posts.add(Post.fromMap(element));
      }
    } catch (e) {
      print(e);
    }
    return posts;
  }
}
