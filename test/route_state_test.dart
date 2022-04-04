import 'package:get/get.dart';
import 'package:rh_collector/data/services/csv_route_service.dart';
import 'package:rh_collector/data/services/fs_selection_service.dart';
import 'package:rh_collector/data/services/mocks/fs_selection_service_mock.dart';
import 'package:rh_collector/data/services/route_service.dart';
import 'package:rh_collector/domain/states/route_state.dart';
import 'package:test/test.dart';

main() {
  final fs = Get.put<FsSelectionService>(FsSelectionServiceMock());
  final service = Get.put<RouteService>(CsvRouteService());
  final state = Get.put<RouteState>(RouteState());
  test('load weekly route', () async {
    (fs as FsSelectionServiceMock).filePath =
        "/home/lavruh/AndroidStudioProjects/RhCollector/test/examples/weekly_route.csv";
    await state.loadRoute();
    expect(state.route.length, 11);
  });
}
