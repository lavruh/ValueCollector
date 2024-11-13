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
import 'package:flutter_test/flutter_test.dart';
import 'package:file/memory.dart';

main() async {
  Get.put<InfoMsgService>(ConsoleInfoMsgService());
  initDependenciesTest();
  MemoryFileSystem fs = MemoryFileSystem();
  final dir = fs.directory('test');
  dir.createSync(recursive: true);
  final testFile = fs.file('${dir.path}/weekly_route.csv');
  testFile.createSync();


  final selectionService = Get.put<FsSelectionService>(FsSelectionServiceMock());
  final meterState = Get.find<MetersState>();
  Get.put<RouteService>(CsvRouteService.test(fs));
  final state = Get.put<RouteState>(RouteState());

  test('load weekly route', () async {
    testFile.writeAsStringSync('BOWTH,Bowth,20');
    (selectionService as FsSelectionServiceMock).filePath = testFile.path;
    meterState.addNewMeter(Meter(id: 'BOWTH', name: "BOWTH", groupId: "W"));
    await state.loadRoute();
    expect(state.route.length, 1);
  });
}
