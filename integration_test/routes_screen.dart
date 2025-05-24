import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/data/services/mocks/fs_selection_service_mock.dart';
import 'package:rh_collector/di.dart';
import 'package:rh_collector/domain/states/data_from_file_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/ui/screens/meters_screen.dart';

import 'utils.dart';

// Routes screen, open route file, get value in route,
//  check meter moved to done, check value retriev is canceled;

Future<void> routesScreenTest(WidgetTester tester) async {
  expect(readyToRun, true);
  (fsSelect as FsSelectionServiceMock).filePath =
      "$appDataPath/meters_test.csv";
  await tester.pumpWidget(testableWidget(const MetersScreen()));
  await tester.pump();
  await Get.find<DataFromFileState>().initImportData();
  await tester.pump();
  await tester.dragFrom(
      tester.getTopLeft(find.byType(MaterialApp)), const Offset(300, 0));
  await tester.pumpAndSettle();
  expect(find.textContaining('Routes'), findsOneWidget);
  await tester.tap(find.textContaining('Routes'));
  await tester.pump(const Duration(seconds: 1));

  expect(find.textContaining('Open route file'), findsOneWidget);
  expect(find.textContaining('Todo(0)'), findsOneWidget);
  expect(find.textContaining('Done(0)'), findsOneWidget);
  expect(find.byIcon(Icons.get_app_outlined), findsOneWidget);
  expect(Get.find<MetersState>().meters.length, greaterThan(0));
  (fsSelect as FsSelectionServiceMock).filePath =
      "$appDataPath/weekly_route.csv";
  await tester.tap(find.byIcon(Icons.get_app_outlined));
  await tester.pump(const Duration(seconds: 1));

  expect(find.textContaining('aux'), findsOneWidget);
  expect(find.textContaining('weekly_route'), findsOneWidget);
  expect(find.textContaining('Todo(11)'), findsOneWidget);
  expect(find.textContaining('Done(0)'), findsOneWidget);
  expect(find.byIcon(Icons.add_a_photo_outlined), findsWidgets);
  await moveToCamScreenAndSetVal(tester: tester, value: '123456');
  expect(find.textContaining('Todo(10)'), findsOneWidget);
  expect(find.textContaining('Done(1)'), findsOneWidget);

  await tester.tap(find.textContaining('Done(1)'));
  await tester.pump(const Duration(seconds: 1));
  expect(find.textContaining('123456'), findsOneWidget);

  await tester.tap(find.textContaining('Todo'));
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.byTooltip('Back'));
  await tester.pump(const Duration(seconds: 1));
  expect(find.textContaining('123456'), findsOneWidget);

  await tester.pump(const Duration(seconds: 5));
}
