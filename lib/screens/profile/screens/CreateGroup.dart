import 'dart:io';

import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:biit_social/models/SVGroupModel.dart';
import 'package:biit_social/screens/profile/screens/FriendsListScreen.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../../utils/FilesPicker.dart';

class SvCreateGroupScreen extends StatefulWidget {
  const SvCreateGroupScreen({super.key});

  @override
  State<SvCreateGroupScreen> createState() => _SvCreateGroupScreenState();
}

class _SvCreateGroupScreenState extends State<SvCreateGroupScreen> {
  TextEditingController titleController = TextEditingController();
  String? category;
  TextEditingController descriptionController = TextEditingController();
  late FriendsStoriesController friendsStoriesController;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    friendsStoriesController = context.read<FriendsStoriesController>();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 50),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: SizedBox(
                            height: context.width() * 0.55,
                            width: context.width() * 0.55,
                            child: path == null
                                ? Image.asset(
                                    'images/socialv/faces/face_4.png',
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error);
                                    },
                                  )
                                : Image.file(
                                    File(path.path),
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error);
                                    },
                                  ),
                          ),
                        ),
                        Positioned(
                            bottom: 10,
                            right: 30,
                            child: GestureDetector(
                              onTap: () async {
                                pickFile(context, 0);
                                setState(() {});
                              },
                              child: Icon(
                                Icons.camera_alt_rounded,
                                size: 50,
                                color: context.primaryColor,
                              ),
                            ))
                      ],
                    ),
                    svGetTextField(context,
                        hint: 'Group Title',
                        label: 'Group Title', validator: (value) {
                      if (value == null || value == '') {
                        return 'Please enter title!';
                      }
                      return null;
                    }, controller: titleController),
                    svGetTextField(context,
                        inputBorder: const OutlineInputBorder(),
                        maxLine: 5,
                        hint: 'Description',
                        label: 'Description',
                        controller: descriptionController),
                    const SizedBox(
                      height: 50,
                    ),
                    svAppButton(
                        context: context,
                        text: 'Add Members',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            friendsStoriesController.group = Group(
                                id: 0,
                                Admin: loggedInUser!.CNIC,
                                name: titleController.text,
                                profile: path != null ? path.path : '');
                            FriendsListScreen(toShow: 'Add Member')
                                .launch(context);
                          }
                        },
                        width: MediaQuery.of(context).size.width),
                  ],
                ),
              ),
            )));
  }
}
