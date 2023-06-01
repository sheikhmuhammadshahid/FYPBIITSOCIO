import 'dart:io';

import 'package:biit_social/Client.dart';
import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:biit_social/utils/FilesPicker.dart';
import 'package:biit_social/utils/getVideoItem.dart';
import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../models/SVGroupModel.dart';
import '../../utils/IPHandleClass.dart';
import '../../utils/SVCommon.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

import 'ChatModel/ChatModel.dart';

class ChatScreen extends StatefulWidget {
  String profileScreen;
  String id;
  String name;
  String section;
  Group? group;
  bool groupChat;
  ChatScreen(
      {super.key,
      required this.id,
      required this.name,
      this.group,
      required this.section,
      required this.groupChat,
      required this.profileScreen});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  Duration position = const Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;
  late ServerClient client;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    friendsStoriesController.chats.clear();

    super.dispose();
  }

  late FriendsStoriesController friendsStoriesController;
  init() {
    friendsStoriesController = context.read<FriendsStoriesController>();

    friendsStoriesController.getChats(widget.id, widget.groupChat);
  }

  final _formKey = GlobalKey<FormState>();
  bool ischanged = true;
  TextEditingController replyController = TextEditingController();
  String date = "";
  @override
  Widget build(BuildContext context) {
    client = context.read<ServerClient>();
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: svGetScaffoldColor(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: svGetScaffoldColor(),
        iconTheme: IconThemeData(color: context.iconColor),
        title: Row(
          children: [
            Stack(
              children: [
                sVProfileImageProvider(
                    IPHandle.profileimageAddress + widget.profileScreen,
                    40,
                    40),
                !widget.groupChat
                    ? Consumer<FriendsStoriesController>(
                        builder: (context, value, child) {
                          return onlineUserIcon(value.friends
                                  .firstWhere(
                                      (element) => element.CNIC == widget.id)
                                  .isOnline ??
                              false);
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(color: Colors.black),
                  ),
                  Text(
                    widget.section,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (widget.groupChat)
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  if (widget.group!.Admin == loggedInUser!.CNIC ||
                      widget.group!.Admin == loggedInUser!.name) ...{
                    PopupMenuItem(
                        child: ListTile(
                      title: Text(
                        'Delete',
                        style: boldTextStyle(),
                      ),
                      leading: Icon(
                        Icons.delete,
                        color: svGetBodyColor(),
                      ),
                    )),
                    // PopupMenuItem(
                    //     child: TextButton(
                    //         onPressed: () {},
                    //         child: Row(
                    //           children: [
                    //             Icon(
                    //               Icons.edit,
                    //               color: svGetBodyColor(),
                    //             ),
                    //             Text(
                    //               'Edit',
                    //               style: boldTextStyle(),
                    //             ),
                    //           ],
                    //         ))),
                  },
                  if (widget.groupChat)
                    PopupMenuItem(
                        child: ListTile(
                      title: Text(
                        'Leave group',
                        style: boldTextStyle(),
                      ),
                      onTap: () async {
                        await friendsStoriesController
                            .leaveGroup(int.parse(widget.id));
                        context.pop();
                        context.pop();
                      },
                      leading: Icon(
                        Icons.exit_to_app,
                        color: svGetBodyColor(),
                      ),
                    )),
                  PopupMenuItem(
                      child: ListTile(
                    onTap: () async {
                      await friendsStoriesController.muteOrUnMute(
                          groupId: widget.group!.id,
                          todo: widget.group!.isMuted ?? false);
                      // ignore: use_build_context_synchronously
                      context.pop();
                      widget.group!.isMuted = !(widget.group!.isMuted ?? false);

                      friendsStoriesController.groups
                          .where((element) => element.id == widget.group!.id)
                          .first
                          .isMuted = widget.group!.isMuted;
                      friendsStoriesController.notifyListeners();
                    },
                    title: Text(
                      widget.group!.isMuted ?? false
                          ? 'Un-Mute group'
                          : 'Mute group',
                      style: boldTextStyle(),
                    ),
                    leading: Icon(
                      widget.group!.isMuted ?? false
                          ? Icons.volume_up
                          : Icons.volume_down,
                      color: svGetBodyColor(),
                    ),
                  )),
                ];
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          const Divider(
            thickness: 1,
          ),
          SingleChildScrollView(child: Consumer<FriendsStoriesController>(
            builder: (context, value, child) {
              return Container(
                padding: const EdgeInsets.only(top: 8),
                height: context.height() * 0.74,
                child: friendsStoriesController.isStoriesLoading
                    ? const SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      ).center()
                    : value.chats.isEmpty
                        ? const Center(
                            child: Text('nothing found'),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: value.chats.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var ch = value.chats[index];
                              if (date != ch.date) {
                                date = ch.date ?? '';
                                ischanged = true;
                              } else {
                                ischanged = false;
                              }
                              return Column(
                                children: [
                                  ischanged
                                      ? ch.date != '' && ch.date != null
                                          ? DateChip(
                                              date: DateTime(
                                                  int.parse(
                                                      ch.date!.split('/')[2]),
                                                  int.parse(
                                                      ch.date!.split('/')[0]),
                                                  int.parse(
                                                      ch.date!.split('/')[1])),
                                            )
                                          : const SizedBox.shrink()
                                      : const SizedBox.shrink(),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      textDirection:
                                          ch.sender ? TextDirection.rtl : null,
                                      children: [
                                        ch.senderImage == ""
                                            ? CircleAvatar(
                                                backgroundColor: context
                                                    .scaffoldBackgroundColor,
                                                backgroundImage: const AssetImage(
                                                    'images/socialv/faces/face_5.png'))
                                            : CircleAvatar(
                                                backgroundColor: context
                                                    .scaffoldBackgroundColor,
                                                // backgroundImage: NetworkImage(
                                                //     profileimageAddress +
                                                //         ch.senderImage),
                                                child: sVProfileImageProvider(
                                                    IPHandle.profileimageAddress +
                                                        ch.senderImage,
                                                    10.0,
                                                    10.0),
                                              ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Column(
                                            children: [
                                              ch.type != 'text'
                                                  ? const Divider(
                                                      thickness: 1,
                                                      height: 5,
                                                    )
                                                  : const SizedBox.shrink(),
                                              ch.type != 'text'
                                                  ? Text(ch.message)
                                                  : const SizedBox.shrink(),
                                              Card(
                                                  color: ch.sender
                                                      ? context.cardColor
                                                      : context.iconColor,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: ch.type == "image"
                                                        ? ch.fromFile
                                                            ? Image.file(
                                                                File(ch.url!),
                                                                height: context
                                                                        .height() *
                                                                    0.3,
                                                                width: context
                                                                        .width() *
                                                                    0.5,
                                                                fit:
                                                                    BoxFit.fill,
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return const Icon(
                                                                      Icons
                                                                          .error);
                                                                },
                                                              )
                                                            : Image.network(
                                                                IPHandle.imageAddress +
                                                                    ch.url!,
                                                                height: context
                                                                        .height() *
                                                                    0.3,
                                                                width: context
                                                                        .width() *
                                                                    0.5,
                                                                fit:
                                                                    BoxFit.fill,
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return const Icon(
                                                                      Icons
                                                                          .error);
                                                                },
                                                              )
                                                        : ch.type == "video"
                                                            ? SizedBox(
                                                                height: context
                                                                        .height() *
                                                                    0.3,
                                                                width: context
                                                                        .width() *
                                                                    0.5,
                                                                child: GetVideoItem(
                                                                    url: ch.fromFile
                                                                        ? ch
                                                                            .url!
                                                                        : IPHandle.imageAddress +
                                                                            ch
                                                                                .url!,
                                                                    fromNetwork:
                                                                        !ch.fromFile),
                                                              )
                                                            : Text(
                                                                ch.message,
                                                                style: TextStyle(
                                                                    color: !ch
                                                                            .sender
                                                                        ? Colors
                                                                            .white
                                                                        : null),
                                                              ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          ch.dateTime.toString(),
                                          style: const TextStyle(
                                              color: Colors.black38),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
              );
            },
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: context.height() * 0.15,
              color: context.scaffoldBackgroundColor,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Divider(
                      thickness: 1,
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          validator: (value) {
                            if (value == '' && isImagePicked == 0) {
                              return 'select something to send!';
                            }
                            return null;
                          },
                          controller: replyController,
                          cursorColor: context.iconColor,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Write a reply"),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              await pickFile(context, 1);
                            },
                            icon: const Icon(Icons.camera_alt)),
                        IconButton(
                            onPressed: () async {
                              await pickFile(context, 2);
                            },
                            icon: const Icon(Icons.filter)),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.file_copy_rounded)),
                        const Spacer(),
                        TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ChatModel ch = ChatModel(
                                    date: date,
                                    fromFile: true,
                                    dateTime: DateTime.now()
                                        .toString()
                                        .splitBetween(' ', '.'),
                                    id: friendsStoriesController
                                            .chats.isNotEmpty
                                        ? friendsStoriesController
                                                .chats[friendsStoriesController
                                                        .chats.length -
                                                    1]
                                                .id +
                                            1
                                        : 1,
                                    message: replyController.text,
                                    sender: true,
                                    senderImage: widget.id,
                                    url:
                                        isImagePicked == 1 || isImagePicked == 2
                                            ? path.path
                                            : "",
                                    type: isImagePicked == 1
                                        ? "image"
                                        : isImagePicked == 2
                                            ? 'video'
                                            : "text");
                                path = null;
                                isImagePicked = 0;
                                replyController.text = "";

                                friendsStoriesController.sendChat(
                                    ch, client, widget.groupChat);
                              }
                            },
                            child: Icon(
                              Icons.send,
                              color: context.iconColor,
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // body: Stack(
      //   fit: StackFit.expand,
      //   children: [
      //     Positioned(
      //       bottom: 0,
      //       child: Row(
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.only(left: 10, right: 10),
      //             child: SizedBox(
      //               width: MediaQuery.of(context).size.width / 1.3 + 20,
      //               child: TextFormField(
      //                 decoration: const InputDecoration(
      //                     border: OutlineInputBorder(),
      //                     hintText: 'Write something here...',
      //                     hintStyle: TextStyle(color: Colors.white)),
      //               ),
      //             ),
      //           ),
      //           IconButton(onPressed: () {}, icon: const Icon(Icons.send))
      //         ],
      //       ),
      //     )
      //   ],
      // ),
    );
  }

  void _changeSeek(double value) {
    setState(() {
      audioPlayer.seek(Duration(seconds: value.toInt()));
    });
  }

  void _playAudio() async {
    const url =
        'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3';
    if (isPause) {
      await audioPlayer.resume();
      setState(() {
        isPlaying = true;
        isPause = false;
      });
    } else if (isPlaying) {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
        isPause = true;
      });
    } else {
      setState(() {
        isLoading = true;
      });
      //  await audioPlayer.play(Source());
      setState(() {
        isPlaying = true;
      });
    }

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
        isLoading = false;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        position = p;
      });
    });
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        duration = const Duration();
        position = const Duration();
      });
    });
  }
}
