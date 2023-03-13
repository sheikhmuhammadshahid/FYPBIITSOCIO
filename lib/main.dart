import 'dart:io';

import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:biit_social/Controllers/PostController.dart';
import 'package:biit_social/Controllers/SettingController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/screens/SVSplashScreen.dart';
import 'package:biit_social/store/AppStore.dart';
import 'package:biit_social/utils/AppTheme.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Controllers/AuthController.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

AppStore appStore = AppStore();
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel_for_partner',
  'High Importance Notifications for partner',
  'This channel is used for important notifications.',
  importance: Importance.defaultImportance,
);
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();

    print('Handling a background message ${message.messageId}');
  } catch (e) {
    print('Exception - main.dart - _firebaseMessagingBackgroundHandler(): $e');
  }
}

setBackground() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print('initialized');
  await setBackground();
  print('set');
  appStore.toggleDarkMode(value: false);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => PostController(),
    ),
    ChangeNotifierProvider(
      create: (_) => FriendsStoriesController(),
    ),
    ChangeNotifierProvider(
      create: (_) => SettingController(),
    ),
    ChangeNotifierProvider(
      create: (_) => AuthController(),
    )
  ], child: const MyApp()));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(seconds: 2)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  init() {
    var initialzationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initialzationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      try {
        if (message.notification != null) {
          Future<String> _downloadAndSaveFile(
              String url, String fileName) async {
            final Directory directory =
                await getApplicationDocumentsDirectory();
            final String filePath = '${directory.path}/$fileName';
            final http.Response response = await http.get(Uri.parse(url));
            final File file = File(filePath);
            await file.writeAsBytes(response.bodyBytes);
            return filePath;
          }

          if (Platform.isAndroid) {
            String bigPicturePath;
            AndroidNotificationDetails androidPlatformChannelSpecifics;
            if (message.notification!.android!.imageUrl != null &&
                '${message.notification!.android!.imageUrl}' != 'N/A') {
              print('${message.notification!.android!.imageUrl}');
              bigPicturePath = await _downloadAndSaveFile(
                  message.notification!.android!.imageUrl ??
                      'https://picsum.photos/200/300',
                  'bigPicture');
              final BigPictureStyleInformation bigPictureStyleInformation =
                  BigPictureStyleInformation(
                FilePathAndroidBitmap(bigPicturePath),
              );
              androidPlatformChannelSpecifics = AndroidNotificationDetails(
                  channel.id, channel.name, channel.description,
                  icon: 'newnotification',
                  styleInformation: bigPictureStyleInformation,
                  playSound: true);
            } else {
              androidPlatformChannelSpecifics = AndroidNotificationDetails(
                  channel.id, channel.name, channel.description,
                  icon: 'newnotification',
                  styleInformation: BigTextStyleInformation(message
                      .notification!.body
                      .toString()
                      .replaceAll('<p>', '')
                      .replaceAll('</p>', '')),
                  playSound: true);
            }
            // final AndroidNotificationDetails androidPlatformChannelSpecifics2 =
            final NotificationDetails platformChannelSpecifics =
                NotificationDetails(android: androidPlatformChannelSpecifics);
            flutterLocalNotificationsPlugin.show(
                1,
                message.notification!.title!
                    .replaceAll('<p>', '')
                    .replaceAll('</p>', ''),
                message.notification!.body!
                    .replaceAll('<p>', '')
                    .replaceAll('</p>', ''),
                platformChannelSpecifics);
          } else if (Platform.isIOS) {
            final String bigPicturePath = await _downloadAndSaveFile(
                message.notification!.apple!.imageUrl ??
                    'https://picsum.photos/200/300',
                'bigPicture.jpg');
            final IOSNotificationDetails iOSPlatformChannelSpecifics =
                IOSNotificationDetails(attachments: <IOSNotificationAttachment>[
              IOSNotificationAttachment(bigPicturePath)
            ], presentSound: true);
            const IOSNotificationDetails iOSPlatformChannelSpecifics2 =
                IOSNotificationDetails(presentSound: true);
            final NotificationDetails notificationDetails = NotificationDetails(
              iOS: message.notification!.apple!.imageUrl != null
                  ? iOSPlatformChannelSpecifics
                  : iOSPlatformChannelSpecifics2,
            );
            await flutterLocalNotificationsPlugin.show(
                1,
                message.notification!.title!
                    .replaceAll('<p>', '')
                    .replaceAll('</p>', ''),
                message.notification!.body!
                    .replaceAll('<p>', '')
                    .replaceAll('</p>', ''),
                notificationDetails);
          }
        }
      } catch (e) {
        print('Exception - main.dart - onMessage.listen(): $e');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        builder: EasyLoading.init(),
        scrollBehavior: SBehavior(),
        navigatorKey: navigatorKey,
        title: 'BIIT SOCIO',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: const SVSplashScreen(),
      ),
    );
  }
}
