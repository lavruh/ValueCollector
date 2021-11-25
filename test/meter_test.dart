import 'package:get/get.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/mocks/db_service_mock.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:test/test.dart';

main() {
  final db = Get.put<DbService>(DbServiceMock.testMeterValues(), tag: "meter");
  late Meter meter;
  late Meter m2;

  setUp(() {
    meter = Meter(groupId: "M", name: "testMeter");
    m2 = Meter(groupId: "D", name: "meter2");
  });

  tearDown(() {
    (db as DbServiceMock).db.clear();
  });
  // TODO update meter value

  // TODO get values
  test('get values', () {
    meter.getValues();
    expect(meter.values.length, 3);
  });

  test('add value', () {
    MeterValue v1 = MeterValue(DateTime.now(), 2);
    MeterValue v2 = MeterValue(DateTime(2016, 8, 26), 4);
    meter.addValue(v1);
    m2.addValue(v2);
    meter.getValues();

    expect(meter.values.any((element) => element == v1), true);
    expect(m2.values.any((element) => element == v2), true);
    expect(
        db.getEntries([
          ["date", ""]
        ]).length,
        1);
  });
}
