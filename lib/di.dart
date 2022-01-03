import 'dart:io';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:rh_collector/data/services/data_from_service.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/mocks/db_service_mock.dart';
import 'package:rh_collector/data/services/pdf_meters_service.dart';
import 'package:rh_collector/domain/states/data_from_file_state.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/domain/states/recognizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rh_collector/domain/states/camera_state.dart';

List<CameraDescription> cameras = [];
String appDataPath = "/storage/emulated/0/ValueCollector";
// TODO store all data in related folder

init_dependencies() async {
  if (Directory(appDataPath).existsSync() == false) {
    final d = Directory(appDataPath).create();
  }
  Get.put<SharedPreferences>(await SharedPreferences.getInstance());
  Get.put<DataFromFileService>(PdfMetersService());
  Get.put<Recognizer>(Recognizer());
  Get.put<CameraState>(CameraState(), permanent: true);
  Get.put<DbService>(DbServiceMock(tableName: "meters"));
  Get.put<MeterGroups>(MeterGroups());
  Get.put<MetersState>(MetersState());
  Get.put<DataFromFileState>(DataFromFileState());
}

init_dependencies_test() {
  Get.put<DataFromFileService>(PdfMetersService());
  Get.put<DbService>(DbServiceMock(tableName: "meters"));
  Get.put<MeterGroups>(MeterGroups());
  Get.put<MetersState>(MetersState());
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
    db.selectTable("meters");
    (db as DbServiceMock).addEntries(values: meters);
    db.selectTable("22");
    (db as DbServiceMock).addEntries(values: meterValues);
  }
}
