import 'package:get/get.dart';
import 'package:rh_collector/data/services/data_from_service.dart';
import 'package:rh_collector/data/services/mocks/data_from_file_mock.dart';
import 'package:rh_collector/di.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/states/data_from_file_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:test/test.dart';

main() async {
  await init_dependencies_test();
  Get.replace<DataFromFileService>(DataFromFileMock());
  final service = Get.put(DataFromFileState());
  List<Map> inp = [
    {
      "id": "knkdsad",
      "name": "somename",
      "date": DateTime(2021, 11, 27),
      "reading": "123456",
    }
  ];

  test("get data from file", () async {
    initTestData();
    final existingMeters = Get.find<MetersState>();
    existingMeters.getMeters(['W']);
    expect(existingMeters.meters, isNotEmpty);
    final fileData = Get.find<DataFromFileService>();
    final meters = Get.find<MetersState>();
    (fileData as DataFromFileMock).addFakeMeter(
        m: Meter(id: "MAINENGPS", name: "ME PS", groupId: "W"),
        v: MeterValue(DateTime(2021, 1, 1), 123));
    Meter newMeter = Meter(id: "newmeter", name: "newmeter", groupId: "W");
    (fileData)
        .addFakeMeter(m: newMeter, v: MeterValue(DateTime(2021, 1, 1), 123));

    await service.getDataFromFile("filePath");

    expect(meters.getMeter("newmeter"), newMeter);
    expect(meters.getMeter("MAINENGPS").values.last.value, 123);
  });
}
