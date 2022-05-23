import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:rh_collector/data/services/console_info_msg_service.dart';
import 'package:rh_collector/data/services/csv_meters_service.dart';
import 'package:rh_collector/data/services/csv_route_service.dart';
import 'package:rh_collector/data/services/data_from_service.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/filepicker_selection_service.dart';
import 'package:rh_collector/data/services/fs_selection_service.dart';
import 'package:rh_collector/data/services/info_msg_service.dart';
import 'package:rh_collector/data/services/mocks/data_from_file_mock.dart';
import 'package:rh_collector/data/services/mocks/db_service_mock.dart';
import 'package:rh_collector/data/services/mocks/fs_selection_service_mock.dart';
import 'package:rh_collector/data/services/pdf_meters_service.dart';
import 'package:rh_collector/data/services/route_service.dart';
import 'package:rh_collector/data/services/sembast_db_service.dart';
import 'package:rh_collector/data/services/snackbar_info_msg_service.dart';
import 'package:rh_collector/domain/states/camera_state_device.dart';
import 'package:rh_collector/domain/states/camera_state_mock.dart';
import 'package:rh_collector/domain/states/data_from_file_state.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/domain/states/rates_state.dart';
import 'package:rh_collector/domain/states/reminders_state.dart';
import 'package:rh_collector/domain/states/recognizer.dart';
import 'package:rh_collector/domain/states/route_state.dart';
import 'package:rh_collector/domain/states/values_calculations_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rh_collector/domain/states/camera_state.dart';

List<CameraDescription> cameras = [];
String appDataPath = "/storage/emulated/0/ValueCollector";

initDependencies() async {
  Get.put<InfoMsgService>(SnackbarInfoMsgService());
  if (Directory(appDataPath).existsSync() == false) {
    Directory(appDataPath).create();
  }
  Get.put<SharedPreferences>(await SharedPreferences.getInstance());
  final db = Get.put<DbService>(SembastDbService(dbName: "metersReadings"));
  await db.openDb();
  Get.put<FsSelectionService>(FilePickerSelectionService());
  Get.put<DataFromFileService>(PdfMetersService(), tag: "bokaPdf");
  Get.put<DataFromFileService>(CsvMetersService(), tag: "csv");
  Get.put<RouteService>(CsvRouteService());
  Get.put<Recognizer>(Recognizer());
  Get.put<CameraState>(CameraStateDevice(), permanent: true);
  Get.put(RatesState());
  Get.lazyPut(() => RemindersState());
  Get.put<MeterGroups>(MeterGroups());
  Get.put<MetersState>(MetersState());
  Get.put<RouteState>(RouteState());
  Get.put<DataFromFileState>(DataFromFileState());
  Get.put(ValuesCalculationsState());
}

initDependenciesTest() {
  Get.put<InfoMsgService>(ConsoleInfoMsgService());
  Get.put<FsSelectionService>(FsSelectionServiceMock());
  Get.put<DataFromFileService>(DataFromFileMock());
  Get.put<DbService>(DbServiceMock(tableName: "meters"));
  Get.put<CameraState>(CameraStateMock(), permanent: true);
  Get.put<MeterGroups>(MeterGroups());
  Get.put<MetersState>(MetersState());
}

Future<bool> isPermissionsGranted() async {
  bool fl = true;
  int v = await getAndroidVersion() ?? 5;
  if (v >= 12) {
    // Request of this permission on old devices leads to crash
    if (fl && await Permission.manageExternalStorage.status.isDenied) {
      fl = await Permission.manageExternalStorage.request().isGranted;
    }
  } else {
    if (fl && await Permission.storage.status.isDenied) {
      fl = await Permission.storage.request().isGranted;
    }
  }
  if (fl && await AwesomeNotifications().isNotificationAllowed() == false) {
    fl = await AwesomeNotifications().requestPermissionToSendNotifications();
  }
  if (fl && await Permission.camera.status.isDenied) {
    fl = await Permission.camera.request().isGranted;
  }
  if (fl && await Permission.microphone.status.isDenied) {
    fl = await Permission.microphone.request().isGranted;
  }
  return fl;
}

Future<int?> getAndroidVersion() async {
  if (Platform.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final androidVersion = androidInfo.version.release ?? '5';
    return int.parse(androidVersion.split('.')[0]);
  }
  return null;
}

initTestData() {
  List<Map<String, dynamic>> meters = [
    {
      "id": "111",
      "name": "m1",
      "groupId": "M",
    },
    {
      "id": "22",
      "name": "AuxEngine",
      "unit": "RH",
      "groupId": "W",
    },
    {
      "id": "3213",
      "name": "m2",
      "groupId": "W",
    },
    {
      "id": "MAINENGPS",
      "name": "ME PS",
      "groupId": "W",
    },
    {
      "id": "MAINENGSB",
      "name": "Main Engine SB",
      "groupId": "W",
    },
    {
      "id": "JETPUHPSB",
      "name": "Jet Pump HP, Jet, Inboard SB",
      "groupId": "W",
    }
  ];
  List<Map<String, dynamic>> meterValues = [
    {
      "id": "111",
      "date": DateTime(2021, 1, 1).millisecondsSinceEpoch,
      "value": 1,
      "correction": 1,
    },
    {
      "id": "222",
      "date": DateTime(2021, 1, 7).millisecondsSinceEpoch,
      "value": 2,
      "correction": 0,
    },
  ];
  final db = Get.find<DbService>();
  if (db.runtimeType == DbServiceMock) {
    (db as DbServiceMock).addEntries(values: meters, table: "meters");
    db.addEntries(values: meterValues, table: "22");
  }
}

String generateId() {
  return DateTime.now().millisecondsSinceEpoch.toString();
}
