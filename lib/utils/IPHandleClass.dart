import '../Controllers/SettingController.dart';

class IPHandle {
  static String ippp = '192.168.224.231';
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
