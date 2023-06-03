import 'package:audioplayers/audioplayers.dart';

import '../Controllers/SettingController.dart';

class IPHandle {
  static final AudioPlayer _player = AudioPlayer();
  static playMessageGot() async {
    try {
      await _player.play(AssetSource('Sounds/messageGot.wav'), volume: 100);
      print('played');
    } catch (e) {
      print("sound");
      print(e);
    }
  }

  static String ippp = '192.168.6.231';
  static String ip = "http://$ippp/BiitSocioApis/api/";
  static String imageAddress = "http://$ippp/BiitSocioApis/postImages/";
  static String profileimageAddress = "http://$ippp/BiitSocioApis/Images/";
  static String storyAddress = 'http://$ippp/BiitSocioApis/Status/';
  static late SettingController settingController;
  static setIp(String ipp) {
    ippp = ipp;
    ip = "http://$ippp/BiitSocioApis/api/";
    imageAddress = "http://$ippp/BiitSocioApis/postImages/";
    profileimageAddress = "http://$ippp/BiitSocioApis/Images/";
    storyAddress = 'http://$ippp/BiitSocioApis/Status/';
  }
}
