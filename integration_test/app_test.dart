import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:rh_collector/data/services/db_service.dart';

import 'groups_menu.dart';
import 'import_search.dart';
import 'meter_editor.dart';
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
    await Get.find<DbService>().clearDb(table: "AUXGENENG");
    await Get.find<DbService>().clearDb(table: "MAINENGSB");
    await Get.find<DbService>().clearDb(table: "MAINENGPS");
    await Get.find<DbService>().clearDb(table: "JETPUHPSB");
  });
  testWidgets("""Overview Screen test""", overviewScreenTest);

  testWidgets("""Groups Menu test""", groupsMenuTest);

  testWidgets("""Routes screen test""", routesScreenTest);

  testWidgets("""Notifications Screen test""", notificationScreenTest);

  testWidgets("Meter editor test", meterEditorTest);

  testWidgets('Import data and search', importDataAndSearchTest);
}
