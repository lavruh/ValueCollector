import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/mocks/db_service_mock.dart';
import 'package:rh_collector/domain/states/recognizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rh_collector/domain/states/camera_state.dart';

List<CameraDescription> cameras = [];

init_dependencies() async {
  Get.put<SharedPreferences>(await SharedPreferences.getInstance());
  Get.put<Recognizer>(Recognizer());
  Get.put<CameraState>(CameraState(), permanent: true);
  Get.put<DbService>(DbServiceMock(tableName: "meters"));
}
