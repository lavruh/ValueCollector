import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:rh_collector/data/services/console_info_msg_service.dart';
import 'package:rh_collector/data/services/info_msg_service.dart';
import 'package:rh_collector/data/services/mocks/fs_selection_service_mock.dart';
import 'package:rh_collector/di.dart';
import 'dart:io';
import 'package:rh_collector/data/services/csv_meters_service.dart';
import 'package:rh_collector/data/services/csv_route_service.dart';
import 'package:rh_collector/data/services/data_from_service.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/fs_selection_service.dart';
import 'package:rh_collector/data/services/pdf_meters_service.dart';
import 'package:rh_collector/data/services/route_service.dart';
import 'package:rh_collector/data/services/sembast_db_service.dart';
import 'package:rh_collector/domain/states/data_from_file_state.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';
import 'package:rh_collector/domain/states/meter_types_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/domain/states/rates_state.dart';
import 'package:rh_collector/domain/states/reminders_state.dart';
import 'package:rh_collector/domain/states/route_state.dart';
import 'package:rh_collector/domain/states/values_calculations_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

late DbService db;
late FsSelectionService fsSelect;

bool readyToRun = false;

Widget testableWidget(Widget w) {
  final ThemeData theme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.grey,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: "Georgia",
  );

  return GetMaterialApp(
    theme: theme,
    home: w,
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en', ''), // English, no country code
      Locale('uk', ''), // Spanish, no country code
    ],
  );
}

Future<bool> initTestApp() async {
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
    await appTestDependencies();
    return true;
  }
  return false;
}

appTestDependencies() async {
  Get.put<InfoMsgService>(ConsoleInfoMsgService());
  if (Directory(appDataPath).existsSync() == false) {
    Directory(appDataPath).create();
  }
  Get.put<SharedPreferences>(await SharedPreferences.getInstance());
  db = Get.put<DbService>(SembastDbService(dbName: "metersReadings"));
  await db.openDb();
  fsSelect = Get.put<FsSelectionService>(FsSelectionServiceMock());

  Get.put<DataFromFileService>(PdfMetersService(), tag: "bokaPdf");
  Get.put<DataFromFileService>(CsvMetersService(), tag: "csv");
  Get.put<RouteService>(CsvRouteService());
  Get.put(MeterTypesState());
  Get.put(RatesState());
  Get.lazyPut(() => RemindersState());
  Get.put<MeterGroups>(MeterGroups());
  Get.put<MetersState>(MetersState());
  Get.put<RouteState>(RouteState());
  Get.put<DataFromFileState>(DataFromFileState());
  Get.put(ValuesCalculationsState());
}

checkDate({
  required String f,
  required WidgetTester tester,
  required Finder fndr,
}) async {
  await tester.tap(find.text(f));
  await tester.pump();
  expect(fndr, findsOneWidget);
  await tester.tap(fndr);
  await tester.pump(const Duration(seconds: 1));
  expect(find.text(f), findsNothing);
  await checkReminderSaveAction(tester: tester);
}

checkReminderSaveAction({required WidgetTester tester}) async {
  expect(find.byIcon(Icons.save), findsOneWidget);
  await tester.tap(find.byIcon(Icons.save));
  await tester.pump(const Duration(seconds: 1));
  expect(find.byIcon(Icons.save), findsNothing);
}

checkReminderWeekday({
  required String s,
  required WidgetTester tester,
}) async {
  final widget = tester.firstWidget<ActionChip>(find.ancestor(
    of: find.text(s),
    matching: find.byType(ActionChip),
  ));
  expect(widget.side, const BorderSide(width: 0));
  await tester.tap(find.text(s));
  await tester.pump(const Duration(seconds: 1));
  expect(
      tester
          .firstWidget<ActionChip>(find.ancestor(
              of: find.text(s), matching: find.byType(ActionChip)))
          .side,
      const BorderSide(width: 3));
  await checkReminderSaveAction(tester: tester);
}

moveToCamScreenAndSetVal({
  required String value,
  required WidgetTester tester,
}) async {
  await tester.tap(find.byIcon(Icons.add_a_photo_outlined).first);
  await tester.pump(const Duration(seconds: 3));
  final input = find.byType(TextField);
  expect(input, findsOneWidget);
  await tester.enterText(input, value);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.tap(find.byIcon(Icons.check));
  await tester.pump(const Duration(seconds: 2));
}
