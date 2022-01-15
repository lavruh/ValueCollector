import 'package:get/get.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/mocks/db_service_mock.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:test/test.dart';

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
    db.selectTable(meter.id);
    (db as DbServiceMock).addEntries(values: values);
    await meter.getValues();
    final val = meter.values.first;
    val.value = 666;
    meter.updateValue(val);
    final res = await db.getEntries([
      ["id", val.id]
    ]);
    expect(meter.values.length, 3);
    expect(meter.values.last.value, val.value);
    expect(res.length, 1);
    expect(res.last['value'], val.value);
  });

  test('get values', () async {
    db.selectTable(meter.id);
    (db as DbServiceMock).addEntries(values: values, keyField: "date");
    await meter.getValues();
    expect(meter.values.length, values.length);
  });

  test('add value', () async {
    MeterValue v1 = MeterValue(DateTime.now(), 2);
    MeterValue v2 = MeterValue(DateTime(2016, 8, 26), 4);
    meter.addValue(v1);
    m2.addValue(v2);
    await meter.getValues();

    expect(meter.values.any((element) => element.value == v1.value), true);
    expect(m2.values.any((element) => element.value == v2.value), true);
    List r = await db.getEntries([
      ["date", ""]
    ]);
    expect(r.length, 1);
  });
}
