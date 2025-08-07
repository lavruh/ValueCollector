import 'package:get/get.dart';
import 'package:rh_collector/data/services/data_from_service.dart';
import 'package:rh_collector/data/services/mocks/data_from_file_mock.dart';
import 'package:rh_collector/di.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/states/data_from_file_state.dart';
import 'package:rh_collector/domain/states/meter_editor_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:flutter_test/flutter_test.dart';

main() async {
  await initDependenciesTest();

  final editor = Get.find<MeterEditorState>();
  final existingMeters = Get.find<MetersState>();
  final fileData = Get.put<DataFromFileService>(DataFromFileMock(), tag: "csv");
  final service = Get.put(DataFromFileState());

  setUp(() async {
    await initTestData();
  });

  tearDown(() {
    final fileData = Get.find<DataFromFileService>();
    (fileData as DataFromFileMock).data.clear();
  });

  test("get data from file", () async {
    await existingMeters.getMeters(['W']);
    expect(existingMeters.meters, isNotEmpty);
    (fileData as DataFromFileMock).addFakeMeter(
        m: Meter(id: "MAINENGPS", name: "ME PS", groupId: "W"),
        v: MeterValue(DateTime(2021, 1, 1), 123, correct: 0));
    final meterValue = MeterValue(DateTime(2021, 1, 1), 123, correct: 0);
    Meter newMeter = Meter(
        id: "newmeter", name: "newmeter", groupId: "W", values: [meterValue]);
    (fileData).addFakeMeter(m: newMeter, v: meterValue);
    int l = existingMeters.meters.length;
    await service.getDataFromFile("filePath");

    expect(existingMeters.getMeter(newMeter.id).id, newMeter.id);
    expect(existingMeters.getMeter(newMeter.id).name, newMeter.name);
    expect(existingMeters.getMeter("MAINENGPS").values.last.value, 123);
    expect(existingMeters.meters.length, l + 1);
  });

  test("export last readings", () async {
    await existingMeters.getMeters(['W']);
    expect(existingMeters.meters, isNotEmpty);
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
    expect(existingMeters.getMeter("MAINENGPS").values.last.value, 123);
    int idx = existingMeters.meters
        .indexWhere((element) => element.id == "MAINENGPS");
    Meter m = existingMeters.getMeter("MAINENGPS");

    expect(existingMeters.meters[idx].values.length, 1);
    final value = MeterValue(DateTime(2021, 1, 1), 345);
    m = await editor.addValueToMeter(value: value, meter: m);
    await existingMeters.updateMeter(m);
    expect(m.values.last.correctedValue, 345);
    service.exportToFile();
    expect(fileData.newValues["MAINENGPS"], "345");
  });

  test("import corrected values", () async {
    await existingMeters.getMeters(['W']);
    Meter meter = Meter(id: "AUXENG", name: "name", groupId: "W");
    await existingMeters.addNewMeter(meter.copyWith(values: []));
    meter = meter.copyWith(correction: 2);
    final value = MeterValue(DateTime(2022, 1, 1), 2);
    meter = await editor.addValueToMeter(value: value, meter: meter);
    expect(meter.values.last.correctedValue, 4);
    expect(meter.values.length, 1);
    await existingMeters.updateMeter(meter);

    (fileData as DataFromFileMock).addFakeMeter(
        m: Meter(id: "AUXENG", name: "Aux engine", groupId: "W"),
        v: MeterValue(DateTime(2021, 2, 2), 666));

    await service.getDataFromFile("filePath");
    meter = existingMeters.getMeter("AUXENG");
    expect(meter.values.length, 2);
    expect(meter.values.last.correction, 0);
    expect(meter.values.last.value, 666);
    expect(meter.values.last.correctedValue, 666);
  });
}
