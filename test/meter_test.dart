import 'package:get/get.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/mocks/db_service_mock.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rh_collector/domain/states/meter_editor_state.dart';

main() {
  final values = [
    {
      "id": "111",
      "date": DateTime.now().millisecondsSinceEpoch,
      "value": 1,
      "correction": 1,
    },
    {
      "id": "222",
      "date": DateTime.now().millisecondsSinceEpoch + 1,
      "value": 2,
      "correction": 0,
    },
    {
      "id": "333",
      "date": DateTime.now().millisecondsSinceEpoch + 2,
      "value": 3,
      "correction": 1,
    },
  ];
  final db = Get.put<DbService>(DbServiceMock());
  final editor = Get.put<MeterEditorState>(MeterEditorState());
  late Meter meter;
  late Meter m2;

  setUp(() {
    meter = Meter(groupId: "M", name: "testMeter");
    m2 = Meter(groupId: "D", name: "meter2");
  });

  tearDown(() {
    (db as DbServiceMock).db.clear();
  });

  test("Update value", () async {
    await (db as DbServiceMock)
        .addEntries(values: values, keyField: "id", table: meter.id);
    editor.set(meter);
    await editor.getValues();
    meter = editor.get();
    expect(meter.values, isNotEmpty);
    final val = meter.values.first;
    val.value = 666;
    await editor.updateValue(val);
    final res = await db.getEntries([
      ["id", val.id]
    ], table: meter.id);
    expect(meter.values.length, 3);
    expect(meter.values.firstWhere((element) => element.id == val.id).value,
        val.value);
    expect(res.length, 1);
    expect(res.last['value'], val.value);
  });

  test('get values', () async {
    await (db as DbServiceMock).addEntries(values: values, table: meter.id);
    editor.set(meter);
    await editor.getValues();
    meter = editor.get();
    expect(meter.values.length, values.length);
  });

  test('add value', () async {
    MeterValue v1 = MeterValue(DateTime.now(), 2);
    MeterValue v2 = MeterValue(DateTime(2016, 8, 26), 4);
    await editor.addValueToMeter(value: v1, meter: meter);
    await editor.addValueToMeter(value: v2, meter: m2);
    editor.set(meter);
    await editor.getValues();
    meter = editor.get();
    editor.set(m2);
    await editor.getValues();
    m2 = editor.get();

    expect(meter.values.any((element) => element.value == v1.value), true);
    expect(m2.values.any((element) => element.value == v2.value), true);
    List r = await db.getEntries([], table: meter.id);
    expect(r.length, 1);
  });

  test('add corrected value', () async {
    MeterValue v1 = MeterValue(DateTime.now(), 2);
    MeterValue v2 = MeterValue(DateTime(2016, 8, 26), 4, correct: 4);
    await editor.addValueToMeter(value: v1, meter: meter);
    await editor.addValueToMeter(value: v2, meter: m2);
    editor.set(meter);
    await editor.getValues();
    meter = editor.get();
    editor.set(m2);
    await editor.getValues();
    m2 = editor.get();

    expect(meter.values.any((element) => element.value == v1.value), true);
    expect(meter.values.any((element) => element.correctedValue == 2), true);
    expect(m2.values.any((element) => element.value == v2.value), true);
    expect(m2.values.any((element) => element.correctedValue == 8), true);
    expect(meter.values.length, 1);
    List r = await db.getEntries([], table: meter.id);
    expect(r.length, 1);
  });
}
