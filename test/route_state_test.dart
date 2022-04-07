import 'dart:developer';

import 'package:get/get.dart';
import 'package:rh_collector/data/services/console_info_msg_service.dart';
import 'package:rh_collector/data/services/csv_route_service.dart';
import 'package:rh_collector/data/services/fs_selection_service.dart';
import 'package:rh_collector/data/services/info_msg_service.dart';
import 'package:rh_collector/data/services/mocks/fs_selection_service_mock.dart';
import 'package:rh_collector/data/services/route_service.dart';
import 'package:rh_collector/di.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/domain/states/route_state.dart';
import 'package:test/test.dart';

main() {
  Get.put<InfoMsgService>(ConsoleInfoMsgService());
  init_dependencies_test();
  final fs = Get.put<FsSelectionService>(FsSelectionServiceMock());
  final meterState = Get.find<MetersState>();
  final service = Get.put<RouteService>(CsvRouteService());
  final state = Get.put<RouteState>(RouteState());
  test('load weekly route', () async {
    (fs as FsSelectionServiceMock).filePath =
        "/home/lavruh/AndroidStudioProjects/RhCollector/test/examples/weekly_route.csv";
    meterState.addNewMeter(Meter(id: 'BOWTH', name: "BOWTH", groupId: "W"));
    await state.loadRoute();
    expect(state.route.length, 1);
  });
}
