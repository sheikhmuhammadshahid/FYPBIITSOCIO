import 'package:biit_social/Controllers/SettingController.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:provider/provider.dart';

class GetVideoItem extends StatefulWidget {
  String url;
  GetVideoItem({required this.url, super.key});

  @override
  State<GetVideoItem> createState() => _GetVideoItemState();
}

class _GetVideoItemState extends State<GetVideoItem>
    with TickerProviderStateMixin {
  late FlickManager flickManager;
  late AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
        widget.url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false),
      ),
    );
    flickManager.onVideoEnd = () {
      // settingController.isPaused = true;
      animationController.reverse();
      //settingController.notifyListeners();
    };
  }

  @override
  void dispose() {
    animationController.dispose();
    flickManager.dispose();
    super.dispose();
  }

  final bool _pauseOnTap = false;
  late SettingController settingController;
  @override
  Widget build(BuildContext context) {
    settingController = Provider.of<SettingController>(context);
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && mounted) {
          flickManager.flickControlManager!.autoPause();
        } else if (visibility.visibleFraction == 1) {
          //settingController.isPaused = false;
          animationController.forward();
          //settingController.notifyListeners();
          flickManager.flickControlManager!.autoResume();
        }
      },
      child: GestureDetector(onTap: () {
        settingController.isMuted = !settingController.isMuted;
        settingController.notifyListeners();
      }, child: Consumer<SettingController>(
        builder: (context, value, child) {
          if (settingController.isMuted) {
            flickManager.flickControlManager!.mute();
          } else {
            flickManager.flickControlManager!.unmute();
          }
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FlickVideoPlayer(
                  flickManager: flickManager,
                  flickVideoWithControls: const FlickVideoWithControls(
                    //videoFit: BoxFit.fill,

                    playerLoadingFallback: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                    // aspectRatioWhenLoading: 16 / 9,
                  ),
                  // flickVideoWithControls: AnimationPlayerPortraitVideoControls(
                  //     dataManager: dataManager, pauseOnTap: _pauseOnTap),
                  // flickVideoWithControlsFullscreen: FlickVideoWithControls(
                  //   controls: AnimationPlayerLandscapeControls(
                  //     animationPlayerDataManager: dataManager,
                  //   ),
                  // ),
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      settingController.isPaused
                          ? {
                              flickManager.flickControlManager!.play(),
                              animationController.forward()
                            }
                          : {
                              flickManager.flickControlManager!.pause(),
                              animationController.reverse()
                            };
                      settingController.isPaused = !settingController.isPaused;
                      settingController.notifyListeners();
                    },
                    child: AnimatedIcon(
                        size: 50,
                        color: Colors.white,
                        icon: AnimatedIcons.play_pause,
                        progress: animationController),
                  )),
              Positioned(
                  // alignment: Alignment.bottomRight,
                  bottom: 10,
                  right: 10,
                  child: GestureDetector(
                      onTap: () {
                        settingController.isMuted = !settingController.isMuted;
                        settingController.notifyListeners();
                      },
                      child: Icon(
                        settingController.isMuted
                            ? Icons.volume_off
                            : Icons.volume_up,
                        color: Colors.white,
                      )))
            ],
          );
        },
      )),
    );
  }
}
