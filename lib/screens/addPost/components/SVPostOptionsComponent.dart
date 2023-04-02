import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:biit_social/utils/SVConstants.dart';

import '../../../utils/FilesPicker.dart';

class SVPostOptionsComponent extends StatefulWidget {
  const SVPostOptionsComponent({super.key});

  @override
  State<SVPostOptionsComponent> createState() => _SVPostOptionsComponentState();
}

class _SVPostOptionsComponentState extends State<SVPostOptionsComponent> {
  List<String> list = [
    'images/socialv/posts/post_one.png',
    'images/socialv/posts/post_two.png',
    'images/socialv/posts/post_three.png',
    'images/socialv/postImage.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: svGetScaffoldColor(),
        borderRadius: radiusOnly(
            topRight: SVAppContainerRadius, topLeft: SVAppContainerRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: (() {
                    pickFile(context, 0);
                  }),
                  child: Image.asset('images/socialv/icons/ic_CameraPost.png',
                      height: 30, width: 30, fit: BoxFit.cover),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: (() {
                    pickFile(context, 0);
                  }),
                  child: Text("click here to choose...",
                      style: secondaryTextStyle(
                        size: 15,
                        color: svGetBodyColor(),
                      )),
                )
                // HorizontalList(
                //   itemCount: list.length,
                //   itemBuilder: (context, index) {
                //     return Image.asset(list[index],
                //         height: 62, width: 52, fit: BoxFit.cover);
                //   },
                // )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          )
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Image.asset('images/socialv/icons/ic_Video.png',
          //         height: 32, width: 32, fit: BoxFit.cover),
          //     //Image.asset('images/socialv/icons/ic_CameraPost.png', height: 32, width: 32, fit: BoxFit.cover),
          //     Image.asset('images/socialv/icons/ic_Voice.png',
          //         height: 32, width: 32, fit: BoxFit.cover),
          //     Image.asset('images/socialv/icons/ic_Location.png',
          //         height: 32, width: 32, fit: BoxFit.cover),
          //     Image.asset('images/socialv/icons/ic_Paper.png',
          //         height: 32, width: 32, fit: BoxFit.cover),
          //   ],
          // ),
        ],
      ),
    );
  }
}
