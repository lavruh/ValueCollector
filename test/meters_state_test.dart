import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/mocks/db_service_mock.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:test/test.dart';

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
  Get.put<DbService>(
      DbServiceMock.testData(values: values, tableName: "meters"));
  MetersState state = Get.put<MetersState>(MetersState());
  test("get meters", () async {
    await state.getMeters(["W"]);
    expect(state.meters.value.length, 2);
  });

  test('Add meter', () async {
    Meter m = Meter(groupId: 'M', name: 'Engine PS');
    await state.updateMeter(m);
    await state.getMeters([m.groupId]);
    expect(state.meters.value.length, 1);
  });

  test('Update meter', () {
    state.getMeters(["W"]);
    Meter m = state.meters.first;
    m.unit = "mm";
    state.updateMeter(m);
    state.getMeters(["W"]);
    expect(state.meters.value.singleWhere((element) => element.id == m.id).unit,
        m.unit);
  });
}
