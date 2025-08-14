import 'package:get/get.dart';
import 'package:rh_collector/data/dtos/meter_dto.dart';
import 'package:rh_collector/data/services/console_info_msg_service.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/info_msg_service.dart';
import 'package:rh_collector/data/services/mocks/db_service_mock.dart';
import 'package:rh_collector/domain/entities/calculated_meter.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rh_collector/domain/states/meter_editor_state.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';

main() {
  final db = Get.put<DbService>(DbServiceMock());
  Get.put<InfoMsgService>(ConsoleInfoMsgService());
  Get.put<MeterGroups>(MeterGroups());
  final editor = Get.put<MeterEditorState>(MeterEditorState());
  final metersState = Get.put<MetersState>(MetersState());
  List<Meter> meters = [
    Meter(
        id: "m1",
        name: "m1",
        groupId: "M",
        values: [MeterValue(DateTime(2022), 5), MeterValue(DateTime.now(), 1)]),
    Meter(name: "m2", groupId: "M", values: [MeterValue(DateTime.now(), 1)]),
    Meter(name: "m3", groupId: "M", values: [MeterValue(DateTime.now(), 1)]),
  ];

  setUp(() {});

  tearDown(() {
    (db as DbServiceMock).db.clear();
  });

  test("Encode and decode meter value", () {
    final sut = CalculatedMeter.empty(name: "name", formula: []);
    for (int i = 0; i < meters.length; i++) {
      final m = meters[i];
      metersState.addNewMeter(m);
    }
    final meter = meters[0];
    String tmp = sut.encodeMeter(meter: meter);
    expect(sut.getValueOfEncodedMeter(tmp), 1);
    tmp = sut.encodeMeter(meter: meter, indexString: "n-1");
    expect(sut.getValueOfEncodedMeter(tmp), 5);
    tmp = sut.encodeMeter(meter: meter, indexString: "n-3");
    expect(sut.getValueOfEncodedMeter(tmp), 0);
    tmp = sut.encodeMeter(meter: meter, indexString: "n+1");
    expect(sut.getValueOfEncodedMeter(tmp), 0);
  });

  test("Add", () async {
    List<String> formula = [];
    CalculatedMeter sut = CalculatedMeter.empty(name: "name", formula: formula);
    for (int i = 0; i < meters.length; i++) {
      final m = meters[i];
      metersState.addNewMeter(m);
      formula.add(sut.encodeMeter(meter: m));
      if (i < meters.length - 1) formula.add("+");
    }

    CalculatedMeter.empty(name: "name", formula: formula);
    editor.set(sut);
    await editor.addValue(MeterValue(DateTime.now(), 0));
    final result = editor.get();
    expect(result is CalculatedMeter, isTrue);
    expect(result.values.length == 1, isTrue);
    expect(result.values.last.value, 3);
  });

  test("n-1", () async {
    List<String> formula = ["m1_n-1", "-", "m1_n"];
    for (int i = 0; i < meters.length; i++) {
      final m = meters[i];
      metersState.addNewMeter(m);
    }

    final sut = CalculatedMeter.empty(name: "name", formula: formula);
    editor.set(sut);
    await editor.addValue(MeterValue(DateTime.now(), 0));
    final result = editor.get();
    expect(result is CalculatedMeter, isTrue);
    expect(result.values.length == 1, isTrue);
    expect(result.values.last.value, 4);
  });

  test("calculated meter to map", () {
    List<String> formula = ["m1_n-1", "-", "m1_n"];
    final sut = CalculatedMeter.empty(name: "name", formula: formula);
    final dto = MeterDto.fromDomain(sut);
    final map = dto.toJson();
    final result = MeterDto.fromJson(map).toDomain();
    expect(result is CalculatedMeter, true);
    if (result is CalculatedMeter) {
      expect(result.id, sut.id);
      expect(result.name, sut.name);
      expect(result.typeId, sut.typeId);
      expect(result.groupId, sut.groupId);
      expect(result.correction, sut.correction);
      expect(result.unit, sut.unit);
      expect(result.values, sut.values);
      expect(result.formula, sut.formula);
    }
  });
}
