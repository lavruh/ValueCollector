import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:rh_collector/app.dart';
import 'di.dart';
import 'package:rh_collector/domain/states/camera_state.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (await isPermissionsGranted()) {
    AwesomeNotifications()
        .initialize('resource://drawable/res_notification_app_icon', [
      NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          defaultColor: Colors.grey,
          channelDescription: 'basic_channel',
          channelShowBadge: true,
          enableLights: true,
          ledColor: Colors.red,
          ledOnMs: 500,
          ledOffMs: 1000,
          enableVibration: true,
          importance: NotificationImportance.High)
    ]);
    cameras = await availableCameras();
    await initDependencies();
    runApp(const App());
    final camera = Get.find<CameraState>();
    camera.disposeCamera();
  } else {
    // exit(0);
  }
}
