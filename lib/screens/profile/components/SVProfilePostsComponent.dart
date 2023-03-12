import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/utils/SVConstants.dart';

class SVProfilePostsComponent extends StatefulWidget {
  const SVProfilePostsComponent({Key? key}) : super(key: key);

  @override
  State<SVProfilePostsComponent> createState() =>
      _SVProfilePostsComponentState();
}

class _SVProfilePostsComponentState extends State<SVProfilePostsComponent> {
  int selectedIndex = 0;

  List<String> allPostList = [
    'images/socialv/posts/post_one.png',
    'images/socialv/posts/post_two.png',
    'images/socialv/posts/post_three.png',
    'images/socialv/posts/post_one.png',
    'images/socialv/posts/post_two.png',
    'images/socialv/posts/post_three.png',
    'images/socialv/posts/post_one.png',
    'images/socialv/posts/post_two.png',
    'images/socialv/posts/post_three.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: context.cardColor, borderRadius: radius(SVAppContainerRadius)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      selectedIndex = 0;
                      setState(() {});
                    },
                    child: Text(
                      'All Post',
                      style: TextStyle(
                        color: textPrimaryColorGlobal,
                        fontSize: 14,
                        fontWeight: selectedIndex == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    height: 2,
                    width: context.width() / 2 - 32,
                    color: selectedIndex == 0
                        ? textPrimaryColorGlobal
                        : textPrimaryColorGlobal.withOpacity(0.5),
                  ),
                ],
              ),
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      selectedIndex = 1;
                      setState(() {});
                    },
                    child: Text(
                      'Mentions',
                      style: TextStyle(
                        color: textPrimaryColorGlobal,
                        fontSize: 14,
                        fontWeight: selectedIndex == 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    height: 2,
                    width: context.width() / 2 - 32,
                    color: selectedIndex == 1
                        ? textPrimaryColorGlobal
                        : textPrimaryColorGlobal.withOpacity(0.5),
                  ),
                ],
              ),
              16.height,
            ],
          ),
          16.height,
          GridView.builder(
            itemCount: allPostList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Image.asset(allPostList[index],
                      height: 100, fit: BoxFit.cover)
                  .cornerRadiusWithClipRRect(8);
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
          ),
        ],
      ),
    );
  }
}
