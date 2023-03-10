import 'dart:convert';

import 'package:biit_social/Controllers/HandleNotification.dart';
import 'package:biit_social/models/Post/PostModel.dart';
import 'package:biit_social/models/Stories/Stories.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import '../utils/FilesPicker.dart';
import '../utils/SVCommon.dart';
import 'SettingController.dart';
import 'package:provider/provider.dart';

class PostController with ChangeNotifier {
  List<Post> posts = [];
  List<Post> pinedPosts = [];

  bool isLoading = false;
  bool isLazyLoading = false;
  int pageNumber = 0;
  bool fromDiary = false;
  String selectedWall = loggedInUser!.userType!;
  setState() {
    try {
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  addPost(Post post, context) async {
    try {
      EasyLoading.show(status: 'Please wait...', dismissOnTap: false);

      //ip = await getIp() + ip;
      isImagePicked = 0;
      var formData = FormData.fromMap({
        'postedBy': post.postedBy,
        'postFor': post.postFor,
        'description': post.description,
        'dateTime': post.dateTime,
        'type': post.type,
        'fromWall': post.fromWall,
        'user': post.user,
        'image': post.type == "image" || post.type == "video"
            ? await MultipartFile.fromFile(post.text)
            : null,
      });

      String url = "${ip}Post/addPost";
      var v = jsonEncode(post.toMap());
      // post.user = "12";
      var response = await Dio().post(url,
          data: formData,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          }));

      EasyLoading.dismiss();
      EasyLoading.showToast(response.data,
          toastPosition: EasyLoadingToastPosition.bottom);
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showToast('Something gone wrong!');
    }
  }

  addStory(Stories post, context) async {
    try {
      EasyLoading.show(status: 'Please wait...', dismissOnTap: false);
      isImagePicked = 0;
      var formData = FormData.fromMap({
        'societyId': post.societyId,
        'text': post.text,
        'color': post.color,
        'type': post.type,
        'image': post.type == "image" || post.type == "video"
            ? await MultipartFile.fromFile(path.path)
            : null,
      });

      String url = "${ip}Post/addStory";
      var v = jsonEncode(post.toMap());
      // post.user = "12";
      var response = await Dio().post(url,
          data: formData,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          }));
      EasyLoading.dismiss();
      EasyLoading.showToast(response.data,
          toastPosition: EasyLoadingToastPosition.bottom);
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showToast('Something gone wrong!');
    }
  }

  likeOrDislikePost(status, index) async {
    try {
      posts[index].isLiked = status;
      if (status) {
        sendNotification(
            'Like',
            'Hey Mr/Ms ${posts[index].userPosted!.name} your post is liked by ${loggedInUser!.name!}',
            posts[index].userPosted!.CNIC);
      }

      http.Response response;
      var data = {
        'postId': posts[index].id,
        'userid': loggedInUser!.CNIC,
        'emogie': "like"
      };
      if (posts[index].likesCount == null) {
        posts[index].likesCount = 0;
      }
      if (status) {
        posts[index].likesCount = posts[index].likesCount! + 1;
        setState();
        response = await http.post(Uri.parse("${ip}Reacts/addReaction"),
            body: jsonEncode(data), headers: headers);
      } else {
        posts[index].likesCount = posts[index].likesCount! - 1;
        setState();
        response = await http.post(Uri.parse("${ip}Reacts/deleteReact"),
            body: jsonEncode(data), headers: headers);
      }
      if (response.statusCode == 200) {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  getPinnedPosts() async {
    try {
      isLoading = true;
      setState();
      String url = "${ip}post/getPinnedPosts?user_id=${loggedInUser!.CNIC}";
      var response = await Dio().get(url);
      //body: post.toJson(), headers: headers);
      if (response.statusCode == 200) {
        var data = response.data;
        pinedPosts.clear();
        for (var element in data) {
          Post p = Post.fromMap(element["post"]);
          p.isFriend = element["isFriend"];
          p.isLiked = element["isLiked"];
          p.isPinned = element["isPinned"];
          pinedPosts.add(p);
        }
      }
    } catch (e) {
      print(e);
    }
    isLoading = false;
    setState();
  }

  getPosts(context) async {
    try {
      if (pageNumber > 1) {
        isLazyLoading = true;
      } else {
        isLoading = true;
      }
      // ip = await getIp() + ip;
      if (pageNumber == 0) {
        posts.clear();
      }
      pageNumber++;

      setState();

      String url =
          "${ip}post/getPosts?cnic='3230440894009'&&pageNumber=$pageNumber&&fromWall=${Provider.of<SettingController>(context, listen: false).selectedWall}";
      //var v = jsonEncode(post.toMap());

      print(url);

      var response = await Dio().get(url);
      //body: post.toJson(), headers: headers);
      if (response.statusCode == 200) {
        if (response.data != "No more posts") {
          if (pageNumber == 1) {
            posts.clear();
          }
          var data = response.data;
          for (var element in data) {
            Post p = Post.fromMap(element["post"]);
            p.isFriend = element["isFriend"];
            p.isLiked = element["isLiked"];
            p.isPinned = element["isPinned"];
            posts.add(p);
          }
        } else {
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(const SnackBar(content: Text('No more posts')));
        }
      } else {}
    } catch (e) {
      print(e);
    }
    isLoading = false;
    setState();
  }

  uploadFile(path, context) async {
    try {
      EasyLoading.show(status: 'Please wait...', dismissOnTap: false);
      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(path),
        'toUpload': 'timeTable'
      });
      var response = await Dio().post('${ip}post/uploadFile',
          data: formData,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          }));
      EasyLoading.dismiss();
      EasyLoading.showToast(response.data,
          toastPosition: EasyLoadingToastPosition.bottom);
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showToast('Something gone wrong!');
    }
  }

  addToDiary(index) async {
    try {
      var data = jsonEncode({
        'user_id': loggedInUser!.CNIC,
        'post_id': posts[index].id,
      });
      var response = await Dio().post("${ip}Post/pinPost",
          data: data, options: Options(headers: headers));
      if (response.statusCode == 200) {
        posts[index].isPinned = true;
        setState();
        // var p = posts.removeAt(index);
        // posts.insert(0, p);
      }
    } catch (e) {
      print(e);
    }
  }

  removeFromDiary(index) async {
    try {
      var response = await Dio().get(
        "${ip}Post/unPinPosts?user_id=${loggedInUser!.CNIC}&&post_id=${posts[index].id}",
      );
      if (response.statusCode == 200) {
        posts[index].isPinned = false;
        setState();
        // var p = posts.removeAt(index);
        // posts.insert(0, p);
      }
    } catch (e) {
      print(e);
    }
  }

  svGetVideoPlayer(file, from, controller) async {
    await controller!.initialize().then((value) {
      setState();
      controller!.play();
    });
    return controller;
  }

  deletePost(index) async {
    try {
      int id = posts[index].id!;
      posts.remove(posts[index]);
      notifyListeners();
      var response = await Dio().get("${ip}Post/deletePost?post_id=$id");
      if (response.statusCode == 200) {}
    } catch (e) {
      print(e);
    }
  }
}
