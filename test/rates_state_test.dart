import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/mocks/db_service_mock.dart';
import 'package:rh_collector/domain/entities/meter_rate.dart';
import 'package:rh_collector/domain/states/rates_state.dart';
import 'package:rh_collector/domain/states/values_calculations_state.dart';

void main() {
  const table = 'MeterRates';
  final db = Get.put<DbService>(DbServiceMock());
  RatesState state = RatesState();

  tearDown(() {
    state.rates.clear();
    db.clearDb(table: table);
  });

  test('add rate', () async {
    final rate = MeterRate(
        meterType: MeterType.coldwater,
        timeRange: DateTimeRange(
            start: DateTime(2022, 1, 1), end: DateTime(2022, 1, 31)),
        rateLimits: {
          10: 0.5,
          20: 1,
          30: 3,
        });
    await state.addRate(rate: rate);
    expect(state.rates.length, 1);
    final res = await db.getEntries([], table: table);
    expect(res.length, 1);
  });

  test('get rates for specific time range', () async {
    for (MeterRate r in testData) {
      await state.addRate(rate: r);
    }
    await state.addRate(
        rate: testData[1].copyWith(
      timeRange:
          DateTimeRange(start: DateTime(2022, 7, 1), end: DateTime(2022, 8, 1)),
    ));
    expect(state.rates.length, 5);
    List<MeterRate> res = state.getRates(
        dateRange: DateTimeRange(
            start: DateTime(2022, 1, 1), end: DateTime(2022, 2, 5)),
        meterType: MeterType.coldwater);
    expect(res.length, 2);
    expect(res, contains(testData[0]));
    expect(res, contains(testData[1]));

    res = state.getRates(
        dateRange: DateTimeRange(
            start: DateTime(2022, 1, 5), end: DateTime(2022, 1, 15)),
        meterType: MeterType.coldwater);

    expect(res.length, 1);
  });

  test('remove rate', () async {
    final rate = testData.first.copyWith(meterType: MeterType.elec);
    await state.addRate(rate: rate);
    expect(state.rates.length, 1);
    await state.removeRate(rate: rate);
    expect(state.rates.contains(rate), false);
    final res = await db.getEntries([], table: table);
    expect(res.length, 0);
  });

  test('get empty list if no rates for specific date', () async {
    List<MeterRate> res = state.getRates(
        dateRange: DateTimeRange(
            start: DateTime(2022, 1, 1), end: DateTime(2022, 2, 5)),
        meterType: MeterType.coldwater);

    expect(res.length, 0);
  });

  test('get lates rate', () async {
    for (MeterRate r in testData) {
      await state.addRate(rate: r);
    }
    final dateRange =
        DateTimeRange(start: DateTime(2022, 3, 1), end: DateTime(2022, 7, 31));
    await state.addRate(rate: testData[0].copyWith(timeRange: dateRange));
    MeterRate res = state.getLatestRate(
        dateRange: DateTimeRange(
            start: DateTime(2022, 1, 1), end: DateTime(2022, 6, 5)),
        meterType: MeterType.coldwater);

    expect(res.timeRange, dateRange);
  });

  test('update entry', () async {
    for (MeterRate r in testData) {
      await state.addRate(rate: r);
    }
    MeterRate newRate = testData[0].copyWith(meterType: MeterType.hotwater);
    await state.updateRate(rate: newRate);
    final res = await db.getEntries([], table: table);
    expect(res.first['id'], newRate.id);
    expect(res.first['meterType'], newRate.meterType.index);
  });
}

List<MeterRate> testData = [
  MeterRate(
      meterType: MeterType.coldwater,
      timeRange: DateTimeRange(
          start: DateTime(2022, 1, 1), end: DateTime(2022, 1, 31)),
      rateLimits: {10: 0.5, 20: 1, 30: 3}),
  MeterRate(
      meterType: MeterType.coldwater,
      timeRange: DateTimeRange(
          start: DateTime(2022, 2, 1), end: DateTime(2022, 2, 28)),
      rateLimits: {10: 1, 20: 2, 30: 3}),
  MeterRate(
      meterType: MeterType.coldwater,
      timeRange: DateTimeRange(
          start: DateTime(2022, 3, 1), end: DateTime(2022, 5, 31)),
      rateLimits: {10: 1, 20: 2, 30: 3}),
  MeterRate(
      meterType: MeterType.gas,
      timeRange: DateTimeRange(
          start: DateTime(2022, 2, 1), end: DateTime(2022, 2, 28)),
      rateLimits: {10: 1, 20: 2, 30: 3}),
];
