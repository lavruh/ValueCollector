import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:rh_collector/data/services/console_info_msg_service.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/info_msg_service.dart';
import 'package:rh_collector/data/services/mocks/db_service_mock.dart';
import 'package:rh_collector/domain/entities/calculation_result.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_production_cost.dart';
import 'package:rh_collector/domain/entities/meter_rate.dart';
import 'package:rh_collector/domain/entities/meter_type.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/entities/meter_value_delta.dart';
import 'package:rh_collector/domain/states/meter_editor_state.dart';
import 'package:rh_collector/domain/states/meter_types_state.dart';
import 'package:rh_collector/domain/states/rates_state.dart';
import 'package:rh_collector/domain/states/values_calculations_state.dart';

final typeRh = MeterType(name: 'rh', id: 'rh');
final typeColdWater = MeterType(name: 'coldwater', id: 'coldwater');

void main() {
  Get.put<DbService>(DbServiceMock(tableName: "meters"));
  Get.put<InfoMsgService>(ConsoleInfoMsgService());
  final editor = Get.put<MeterEditorState>(MeterEditorState());
  final types = Get.put(MeterTypesState());
  Get.put(RatesState());
  types.addMeterType(typeRh);
  types.addMeterType(typeColdWater);
  final service = ValuesCalculationsState();
  Meter testMeter = Meter(name: "name", groupId: "W");

  setUp(() {});

  tearDown(() {
    testMeter.values.clear();
  });

  test("perform delta calculation on values", () async {
    testMeter = testMeter.copyWith(values: [
      MeterValue(DateTime(2022, 1, 1), 1),
      MeterValue(DateTime(2022, 1, 2), 142),
      MeterValue(DateTime(2022, 1, 3), 14),
      MeterValue(DateTime(2022, 1, 4), 14),
    ]);

    editor.set(testMeter.copyWith(typeId: typeRh.id));
    testMeter = editor.get();

    service.setCalculationStrategie(0);
    await service.calculate();
    List<CalculationResult> res = service.calculationResults;

    expect(res.length, 3);
    expect(res.first.runtimeType, MeterValueDelta);
    expect(res[0].value, 141);
    expect(res[1].value, 14 - 142);
    expect(res[2].value, 0);
  });

  test('perform meter value price calc in one rate limit', () async {
    testMeter = testMeter.copyWith(values: [
      MeterValue(DateTime(2022, 1, 1), 1),
      MeterValue(DateTime(2022, 1, 2), 9),
      MeterValue(DateTime(2022, 1, 3), 28),
      MeterValue(DateTime(2022, 1, 4), 60),
      MeterValue(DateTime(2022, 1, 5), 40),
    ]);
    editor.set(testMeter.copyWith(typeId: typeRh.id));
    testMeter = editor.get();

    Get.find<RatesState>().addRate(
      rate: MeterRate(
          meterType: typeColdWater.id,
          timeRange: DateTimeRange(
              start: DateTime(2022, 1, 1), end: DateTime(2022, 1, 31)),
          rateLimits: {20: 1}),
    );
    testMeter = editor.get().copyWith(typeId: typeColdWater.id);
    editor.set(testMeter);

    service.setCalculationStrategie(1);
    await service.calculate();
    List<CalculationResult> res = service.calculationResults;
    expect(res.length, 4);
    expect(res.first.runtimeType, MeterProductionCost);
    expect(res[0].value, 8);
    expect(res[1].value, 19);
    expect(res[2].value, 10 + 20 + 2);
    expect(res[3].value, 0);
  });

  test('perform meter value price calc in few rate limits', () async {
    testMeter = testMeter.copyWith(values: [
      MeterValue(DateTime(2022, 1, 1), 1),
      MeterValue(DateTime(2022, 1, 2), 9),
      MeterValue(DateTime(2022, 1, 3), 28),
      MeterValue(DateTime(2022, 1, 4), 60),
      MeterValue(DateTime(2022, 1, 5), 40),
    ]);
    editor.set(testMeter.copyWith(typeId: typeRh.id));
    testMeter = editor.get();

    Get.find<RatesState>().addRate(
      rate: MeterRate(
          meterType: typeColdWater.id,
          timeRange: DateTimeRange(
              start: DateTime(2022, 1, 1), end: DateTime(2022, 1, 31)),
          rateLimits: {10: 0.5, 20: 1, 30: 3}),
    );
    testMeter = editor.get().copyWith(typeId: typeColdWater.id);
    editor.set(testMeter);

    service.setCalculationStrategie(1);
    await service.calculate();
    List<CalculationResult> res = service.calculationResults;
    expect(res.length, 4);
    expect(res.first.runtimeType, MeterProductionCost);
    expect(res[0].value, 8 * 0.5);
    expect(res[1].value, 10 * 0.5 + 9);
    expect(res[2].value, 10 * 0.5 + 20 + 2 * 3);
    expect(res[3].value, 0);
  });

  test('perform meter value price calc max rate', () async {
    testMeter = testMeter.copyWith(values: [
      MeterValue(DateTime(2022, 1, 1), 1),
      MeterValue(DateTime(2022, 1, 2), 9),
      MeterValue(DateTime(2022, 1, 3), 28),
      MeterValue(DateTime(2022, 1, 4), 60),
      MeterValue(DateTime(2022, 1, 5), 40),
    ]);
    editor.set(testMeter.copyWith(typeId: typeRh.id));
    testMeter = editor.get();

    Get.find<RatesState>().addRate(
      rate: MeterRate(
          meterType: typeColdWater.id,
          timeRange: DateTimeRange(
              start: DateTime(2022, 1, 1), end: DateTime(2022, 1, 31)),
          rateLimits: {10: 0.5, 15: 1, 30: 3}),
    );

    testMeter = editor.get().copyWith(typeId: typeColdWater.id);
    editor.set(testMeter);

    service.setCalculationStrategie(2);
    await service.calculate();
    List<CalculationResult> res = service.calculationResults;
    expect(res.length, 4);
    expect(res.first.runtimeType, MeterProductionCost);
    expect(res[0].value, 8 * 0.5);
    expect(res[1].value, 19);
    expect(res[2].value, 32 * 3);
    expect(res[3].value, 0);
  });
}
