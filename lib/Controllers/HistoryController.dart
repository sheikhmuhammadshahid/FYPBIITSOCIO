import 'package:hive/hive.dart';

import '../models/Post/PostModel.dart';

class HistoryController {
  static savePosts(List<Post> posts) async {
    try {
      // String url =
      //     "${IPHandle.ip}post/getPostsForHistory?userCnic=${loggedInUser!.CNIC}&lastSavedPostId=1";
      // //var v = jsonEncode(post.toMap());

      // print(url);

      Box postsBox = Hive.box('Posts');
      // var response = await Dio().get(url);
      //body: post.toJson(), headers: headers);
      // if (response.statusCode == 200) {
      //   postsBox.clear();
      //var data = response.data;
      for (var element in posts) {
        if (!postsBox.containsKey(element.id.toString())) {
          await postsBox.put(element.id.toString(), element.toMap());
          print('${element.id} added');
        } else {
          print('${element.id} already');
        }
        //await postsBox.put(p.id, p.toMap());
      }
      //  }
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
      for (int i = 0; i < data.length; i++) {
        posts.add(Post.fromMap(data[i].cast<String, dynamic>()));
      }
    } catch (e) {
      print(e);
    }
    return posts;
  }
}
