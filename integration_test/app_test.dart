// @Skip("Runs on device, takes few minutes")
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';

import 'groups_menu.dart';
import 'import_search.dart';
import 'meter_calculations.dart';
import 'meter_editor.dart';
import 'meter_types_and_rates.dart';
import 'notification_screen.dart';
import 'overview_screen.dart';
import 'routes_screen.dart';
import 'utils.dart';

void main() async {
  setUp(() async {
    readyToRun = await initTestApp();
  });

  tearDown(() async {
    await Get.find<DbService>().clearDb(table: "meters");
    await Get.find<DbService>().clearDb(table: "groups");
    await Get.find<DbService>().clearDb(table: "MeterTypes");
    await Get.find<DbService>().clearDb(table: "MeterRates");
    await Get.find<DbService>().clearDb(table: "AUXGENENG");
    await Get.find<DbService>().clearDb(table: "MAINENGSB");
    await Get.find<DbService>().clearDb(table: "MAINENGPS");
    await Get.find<DbService>().clearDb(table: "JETPUHPSB");
    Get.find<MeterGroups>().selected.value = ['W'];
    Get.find<MetersState>().meters.clear();
  });
  testWidgets("""Overview Screen test""", overviewScreenTest);

  testWidgets("""Groups Menu test""", groupsMenuTest);

  testWidgets("""Routes screen test""", routesScreenTest);

  testWidgets("""Notifications Screen test""", notificationScreenTest);

  testWidgets("Meter editor test", meterEditorTest);

  testWidgets('Import data and search', importDataAndSearchTest);

  testWidgets('Types and rates screens', typesAndRatesScreen);

  testWidgets('meter calculations', meterCalculations);
}
