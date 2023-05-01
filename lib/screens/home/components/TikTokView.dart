import 'package:biit_social/Controllers/PostController.dart';
import 'package:biit_social/Controllers/SettingController.dart';
import 'package:biit_social/screens/home/components/GetTikTokItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TikTokView extends StatefulWidget {
  int index;
  TikTokView({required this.index, super.key});

  @override
  State<TikTokView> createState() => _TikTokViewState();
}

class _TikTokViewState extends State<TikTokView> {
  late PageController pageController;

  late PostController postController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pageController = PageController(initialPage: 0);
    dothis();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }

  dothis() {
    Future.delayed(const Duration(milliseconds: 200))
        .then((value) => pageController.animateToPage(widget.index,
            duration: const Duration(
              milliseconds: 1100,
            ),
            curve: Curves.linearToEaseOut));
  }

  @override
  Widget build(BuildContext context) {
    postController = Provider.of<PostController>(context);
    SettingController settingController =
        Provider.of<SettingController>(context);
    return Consumer<PostController>(
      builder: (context, value, child) {
        return PageView.builder(
          onPageChanged: (val) {
            if (val == postController.posts.length - 1) {
              postController.getPosts(context);
            }
          },
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          controller: pageController,
          itemCount: value.posts.length,
          itemBuilder: (context, index) {
            return getTikTokItem(value, index, context);
          },
        );
      },
    );
  }
}
