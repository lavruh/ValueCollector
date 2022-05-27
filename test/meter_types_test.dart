import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/data/dtos/meter_type_dto.dart';
import 'package:rh_collector/data/services/console_info_msg_service.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/info_msg_service.dart';
import 'package:rh_collector/data/services/mocks/db_service_mock.dart';
import 'package:rh_collector/domain/entities/meter_type.dart';
import 'package:rh_collector/domain/states/meter_types_state.dart';

void main() {
  const table = 'MeterTypes';
  Get.put<InfoMsgService>(ConsoleInfoMsgService());
  final db = Get.put<DbService>(DbServiceMock());
  final state = MeterTypesState();

  tearDown(() {
    state.meterTypes.clear();
    db.clearDb(table: table);
  });

  test('set get icon', () {
    int code = Icons.water.codePoint;
    IconData d = state.getIcon(code);
    expect(d.codePoint, code);
    expect(() => state.getIcon(Icons.abc.codePoint),
        throwsA(isA<MeterTypeException>()));
  });

  test('add meter type', () async {
    final type = MeterType(name: "name");

    await state.addMeterType(type);

    expect(state.meterTypes.length, 1);
    expect(state.meterTypes.values, contains(type));
    var res = await db.getEntries([], table: table);
    expect(res.first.values, contains(type.id));
  });

  test('remove meter', () async {
    final type = MeterType(name: "name");
    await state.addMeterType(type);
    await state.removeMeterType(type.id);
    expect(state.meterTypes.length, 0);
    var res = await db.getEntries([], table: table);
    expect(res.length, 0);
  });

  test('update meter type', () async {
    final type = MeterType(name: "name");
    await state.addMeterType(type);
    const update = "new name";
    final updatedType = state.meterTypes.values.first.copyWith(name: update);
    await state.updateMeterType(updatedType);
    expect(state.meterTypes.values, contains(updatedType));
    var res = await db.getEntries([], table: table);
    expect(res.first.values, contains(updatedType.id));
    expect(res.first.values, contains(updatedType.name));
  });

  test('load types from db', () async {
    for (int i = 0; i < 3; i++) {
      await db.addEntry(
          MeterTypeDto.fromDomain(MeterType(name: "test$i", id: i.toString()))
              .toMap(),
          table: table);
    }
    await state.getMeterTypes();
    expect(state.meterTypes.values.length, 3);
  });

  test('get meter type by id', () async {
    final type = MeterType(name: "name");
    await state.addMeterType(type);
    expect(state.getMeterTypeById(type.id).name, type.name);
  });
}
