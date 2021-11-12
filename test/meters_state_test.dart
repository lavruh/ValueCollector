import 'package:get/get.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/mocks/db_service_mock.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:test/test.dart';

main() {
  Get.put<DbService>(DbServiceMock.testMeters(), tag: "meters");
  MetersState state = Get.put<MetersState>(MetersState());
  test("get meters", () {
    state.getMeters("W");
    expect(state.meters.value.length, 2);
  });

  test('Add meter', () {
    Meter m = Meter(groupId: 'M', name: 'Engine PS');
    state.updateMeter(m);
    state.getMeters(m.groupId);
    expect(state.meters.value.length, 1);
  });

  // TODO Update meter
  test('Update meter', () {
    state.getMeters("W");
    Meter m = state.meters.first;
    m.unit = "mm";
    state.updateMeter(m);
    state.getMeters("W");
    expect(state.meters.value.singleWhere((element) => element.id == m.id).unit,
        m.unit);
  });
}
