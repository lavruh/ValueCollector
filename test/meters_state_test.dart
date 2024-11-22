import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/data/services/console_info_msg_service.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/info_msg_service.dart';
import 'package:rh_collector/data/services/mocks/db_service_mock.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  List<Map<String, dynamic>> values = [
    {
      "id": UniqueKey().toString(),
      "name": "m1",
      "groupId": "",
    },
    {
      "id": UniqueKey().toString(),
      "name": "name",
      "unit": "unit",
      "groupId": "W",
    },
    {
      "id": UniqueKey().toString(),
      "name": "m2",
      "groupId": "W",
    }
  ];

  Get.put<InfoMsgService>(ConsoleInfoMsgService());
  Get.put<DbService>(
      DbServiceMock.testData(values: values, tableName: "meters"));
  Get.put(MeterGroups());
  MetersState state = Get.put<MetersState>(MetersState());
  test("get meters", () async {
    await state.addNewMeter(Meter(name: "another", groupId: "M"));
    await state.addNewMeter(Meter(name: "other2", groupId: "M"));
    await state.getMeters(["W"]);
    expect(state.meters.length, 2);
    await state.getMeters(["M"]);
    expect(state.meters.length, 2);
    await state.getMeters(["M", "W"]);
    expect(state.meters.length, 4);
  });

  test('Add meter', () async {
    Meter m = Meter(groupId: 'MN', name: 'Engine PS');
    await state.addNewMeter(m);
    await state.getMeters([m.groupId]);
    expect(state.meters.length, 1);
  });

  test('Update meter', () async {
    await state.getMeters(["W"]);
    Meter m = state.meters.first;
    m.unit = "mm";
    await state.updateMeter(m);
    await state.getMeters(["W"]);
    expect(
        state.meters.singleWhere((element) => element.id == m.id).unit, m.unit);
  });

  test('Delete meter', () async {
    await state.getMeters(["W"]);
    Meter m = state.meters.first;
    await state.deleteMeter(m.id);
    await state.getMeters(["W"]);
    expect(state.meters.any((element) => element.id == m.id), false);
  });

  test('filter meters', () async {
    await state.addNewMeter(Meter(name: "another", groupId: "W"));
    await state.addNewMeter(Meter(name: "other2", groupId: "M"));
    await state.addNewMeter(Meter(name: "Meter", groupId: "W"));
    await state.addNewMeter(Meter(name: "mNew", groupId: "W"));
    await state.addNewMeter(Meter(name: "some", groupId: "W"));

    await state.filterMetersByName(filter: "", groupId: ["W"]);
    expect(state.meters.length, 4);

    await state.filterMetersByName(filter: "m", groupId: ["W"]);
    expect(state.meters.length, 3);
  });
}
