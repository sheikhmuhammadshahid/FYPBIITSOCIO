import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:biit_social/utils/SVConstants.dart';

class SVPostTextComponent extends StatelessWidget {
  TextEditingController controller;
  SVPostTextComponent({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: svGetScaffoldColor(), borderRadius: radius(SVAppCommonRadius)),
      child: TextField(
        autofocus: false,
        controller: controller,
        maxLines: 7,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Whats On Your Mind',
          hintStyle: secondaryTextStyle(size: 12, color: svGetBodyColor()),
        ),
      ),
    );
  }
}
