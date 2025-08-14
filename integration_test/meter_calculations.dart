import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_rate.dart';
import 'package:rh_collector/domain/entities/meter_type.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/states/meter_types_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/domain/states/rates_state.dart';
import 'package:rh_collector/ui/screens/meters_screen.dart';

import 'utils.dart';

/// Add meter and values, type and rate
/// Open meter editor, values calculation
/// Check difference calculation, change meter type and calculation type
Future<void> meterCalculations(WidgetTester tester) async {
  expect(readyToRun, true);
  final meterState = Get.find<MetersState>();
  final meter = Meter(name: "meter1", groupId: "W").copyWith(values: [
    MeterValue(DateTime(2022, 1, 1), 1),
    MeterValue(DateTime(2022, 1, 2), 2),
    MeterValue(DateTime(2022, 1, 3), 3),
    MeterValue(DateTime(2022, 1, 4), 10),
    MeterValue(DateTime(2022, 1, 5), 30),
  ]);
  meterState.addNewMeter(meter);

  final meterTypes = Get.find<MeterTypesState>();
  final type = MeterType(name: "elec", id: "elec");
  final type2 = MeterType(name: "gas", id: "gas");
  meterTypes.addMeterType(type);
  meterTypes.addMeterType(type2);

  final rates = Get.find<RatesState>();
  rates.addRate(
      rate: MeterRate(
          meterType: type.id,
          timeRange: DateTimeRange(
              start: DateTime(2022, 1, 1), end: DateTime(2023, 1, 1)),
          rateLimits: {1: 1.0}));
  rates.addRate(
      rate: MeterRate(
          meterType: type2.id,
          timeRange: DateTimeRange(
              start: DateTime(2022, 1, 1), end: DateTime(2023, 1, 1)),
          rateLimits: {1: 10.0}));

  await tester.pumpWidget(testableWidget(const MetersScreen()));
  await tester.pumpAndSettle();
  await tester.pump();
  await tester.tap(find.text(meter.name));
  await tester.pumpAndSettle();
  expect(find.byIcon(Icons.calculate), findsOneWidget);
  await tester.tap(find.byIcon(Icons.calculate));
  await tester.pumpAndSettle();
  expect(find.textContaining('Running hours'), findsOneWidget);
  expect(find.textContaining('Difference'), findsOneWidget);
  expect(find.byType(ListTile), findsNWidgets(meter.values.length - 1));
  await tester.tap(find.textContaining('Running hours'));
  await tester.pumpAndSettle();
  await tester.tap(find.textContaining(type.name).last);
  await tester.pumpAndSettle();
  await tester.tap(find.textContaining('Difference'));
  await tester.pumpAndSettle();
  await tester.tap(find.textContaining('Production cost').last);
  await tester.pumpAndSettle();

  await tester.pump(const Duration(seconds: 10));
}
