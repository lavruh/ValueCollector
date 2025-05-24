import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rh_collector/app.dart';
import 'di.dart';
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
    await initDependencies();
    runApp(const App());
  }
}
