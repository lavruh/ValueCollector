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
  await initDependenciesTest();
  Get.replace<DataFromFileService>(DataFromFileMock());
  final service = Get.put(DataFromFileState());

  setUp(() async {
    await initTestData();
  });

  tearDown(() {
    final fileData = Get.find<DataFromFileService>();
    (fileData as DataFromFileMock).data.clear();
  });

  test("get data from file", () async {
    final existingMeters = Get.find<MetersState>();
    await existingMeters.getMeters(['W']);
    expect(existingMeters.meters, isNotEmpty);
    final fileData = Get.find<DataFromFileService>();
    final meters = Get.find<MetersState>();
    (fileData as DataFromFileMock).addFakeMeter(
        m: Meter(id: "MAINENGPS", name: "ME PS", groupId: "W"),
        v: MeterValue(DateTime(2021, 1, 1), 123));
    Meter newMeter = Meter(id: "newmeter", name: "newmeter", groupId: "W");
    (fileData)
        .addFakeMeter(m: newMeter, v: MeterValue(DateTime(2021, 1, 1), 123));
    int l = meters.meters.length;
    await service.getDataFromFile("filePath");

    expect(Get.find<Meter>(tag: newMeter.id), newMeter);
    expect(Get.find<Meter>(tag: "MAINENGPS").values.last.value, 123);
    expect(meters.meters.length, l + 1);
  });

  test("export last readings", () async {
    final existingMeters = Get.find<MetersState>();
    await existingMeters.getMeters(['W']);
    expect(existingMeters.meters, isNotEmpty);
    final fileData = Get.find<DataFromFileService>();
    final meters = Get.find<MetersState>();
    (fileData as DataFromFileMock).addFakeMeter(
        m: Meter(id: "MAINENGPS", name: "ME PS", groupId: "W"),
        v: MeterValue(DateTime(2021, 1, 1), 123));
    fileData.addFakeMeter(
        m: Meter(id: "MAINENGSB", name: "ME SB", groupId: "W"),
        v: MeterValue(DateTime(2021, 1, 1), 123));
    fileData.addFakeMeter(
        m: Meter(id: "EMENG", name: "EM", groupId: "W"),
        v: MeterValue(DateTime(2021, 1, 1), 123));
    await service.getDataFromFile("");
    expect(Get.find<Meter>(tag: "MAINENGPS").values.last.value, 123);
    int idx = meters.meters.indexWhere((element) => element.id == "MAINENGPS");
    final m = Get.find<Meter>(tag: "MAINENGPS");
    expect(meters.meters[idx].values.length, 1);
    await m.addValue(MeterValue(DateTime(2021, 1, 1), 345));

    expect(m.values.last.correctedValue, 345);

    service.exportToFile();
    expect(fileData.newValues["MAINENGPS"], "345");
  });

  test("import corrected values", () async {
    final existingMeters = Get.find<MetersState>();
    await existingMeters.getMeters(['W']);
    expect(existingMeters.meters, isNotEmpty);
    Meter meter = Get.find<Meter>(tag: "MAINENGSB");
    meter.values.clear();
    expect(meter.values.length, 0);
    meter.correction = 2;
    await meter.addValue(MeterValue(DateTime(2022, 1, 1), 2));
    expect(meter.values.last.correctedValue, 4);
    expect(meter.values.length, 1);

    final fileData = Get.find<DataFromFileService>();
    (fileData as DataFromFileMock).addFakeMeter(
        m: Meter(id: "MAINENGSB", name: "ME SB", groupId: "W"),
        v: MeterValue(DateTime(2021, 2, 2), 666));

    await service.getDataFromFile("filePath");
    // meter = Get.find<Meter>(tag: "MAINENGSB");
    expect(meter.values.length, 2);
    expect(meter.values.last.correction, 0);
    expect(meter.values.last.value, 666);
    expect(meter.values.last.correctedValue, 666);
  });
}
