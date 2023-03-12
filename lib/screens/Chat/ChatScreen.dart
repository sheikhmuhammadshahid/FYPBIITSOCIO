import 'package:biit_social/screens/Chat/ChatModel/ChatModel.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import '../../utils/SVCommon.dart';
import 'package:audioplayers/audioplayers.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatModel> chats = [
    ChatModel(
        id: 1,
        message: 'Hi',
        type: 'text',
        sender: true,
        senderImage: 'images/socialv/faces/face_2.png'),
    ChatModel(
        id: 2,
        type: 'text',
        message: 'How are You',
        sender: false,
        senderImage: 'images/socialv/faces/face_2.png'),
    ChatModel(
        id: 3,
        type: 'text',
        message: 'I am fine',
        sender: true,
        senderImage: 'images/socialv/faces/face_2.png'),
    ChatModel(
        id: 4,
        message: 'Whats going on...',
        sender: true,
        type: 'text',
        senderImage: 'images/socialv/faces/face_2.png'),
    ChatModel(
        id: 5,
        message: 'Creating Chat Gui',
        sender: false,
        type: 'text',
        senderImage: 'images/socialv/faces/face_2.png')
  ];
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  Duration position = const Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      backgroundColor: svGetScaffoldColor(),
      appBar: AppBar(
        backgroundColor: svGetScaffoldColor(),
        iconTheme: IconThemeData(color: context.iconColor),
        title: Row(
          children: [
            Image.asset('images/socialv/faces/face_2.png',
                    height: 52, width: 52, fit: BoxFit.cover)
                .cornerRadiusWithClipRRect(100),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: const [
                Text(
                  'Name',
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  'BSCS7C',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    child: TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              color: svGetBodyColor(),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Delete',
                              style: boldTextStyle(),
                            ),
                          ],
                        ))),
                PopupMenuItem(
                    child: TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              color: svGetBodyColor(),
                            ),
                            Text(
                              'Edit',
                              style: boldTextStyle(),
                            ),
                          ],
                        ))),
                PopupMenuItem(
                    child: TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(
                              Icons.exit_to_app,
                              color: svGetBodyColor(),
                            ),
                            Text(
                              'Left group',
                              style: boldTextStyle(),
                            ),
                          ],
                        ))),
                PopupMenuItem(
                    child: TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(
                              Icons.volume_off,
                              color: svGetBodyColor(),
                            ),
                            Text(
                              'Mute group',
                              style: boldTextStyle(),
                            ),
                          ],
                        )))
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                for (var v in chats) ...{
                  if (v.type == 'audio') ...{
                    BubbleNormalAudio(
                      color: const Color(0xFFE8E8EE),
                      duration: duration.inSeconds.toDouble(),
                      position: position.inSeconds.toDouble(),
                      isPlaying: isPlaying,
                      isLoading: isLoading,
                      isPause: isPause,
                      onSeekChanged: _changeSeek,
                      onPlayPauseButtonClick: _playAudio,
                      sent: true,
                    ),
                  } else if (v.type == 'text') ...{
                    BubbleNormal(
                      text: v.message,
                      isSender: v.sender,
                      color: v.sender ? const Color(0xFF1B97F3) : Colors.grey,
                      tail: true,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  }
                },
                DateChip(
                  date: DateTime(now.year, now.month, now.day - 1),
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
          MessageBar(
            onSend: (text) {
              chats.add(ChatModel(
                  id: chats[chats.length - 1].id + 1,
                  message: text,
                  sender: true,
                  senderImage: "",
                  type: 'text'));
              setState(() {});
            },
            actions: [
              InkWell(
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 24,
                ),
                onTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: InkWell(
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.green,
                    size: 24,
                  ),
                  onTap: () {},
                ),
              ),
            ],
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
