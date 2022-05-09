import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:rh_collector/data/services/mocks/fs_selection_service_mock.dart';
import 'package:rh_collector/di.dart';
import 'package:rh_collector/ui/screens/meters_screen.dart';

import 'utils.dart';

// import meters from csv to weekly,
// change to monthly, import meters from pdf,
// select all groups from panel, search meter,
// export to csv or/and pdf???
// export weekly to csv and import same file???

Future<void> importDataAndSearchTest(WidgetTester tester) async {
  expect(readyToRun, true);
  (fsSelect as FsSelectionServiceMock).filePath =
      appDataPath + "/meters_test.csv";
  await tester.pumpWidget(testableWidget(const MetersScreen()));
  await tester.pump();
  expect(find.text('(Weekly)'), findsOneWidget);
  await tester.dragFrom(
      tester.getTopLeft(find.byType(MaterialApp)), const Offset(300, 0));
  await tester.pumpAndSettle();
  expect(find.textContaining('Import'), findsOneWidget);
  await tester.tap(find.textContaining('Import'));
  await tester.pump(const Duration(seconds: 1));
  expect(find.textContaining('/meters_test.csv'), findsOneWidget);
  expect(find.byIcon(Icons.add_a_photo_outlined), findsNWidgets(11));
  await tester.tapAt(const Offset(400, 0));
  await tester.pump(const Duration(seconds: 1));
  expect(find.byIcon(Icons.checklist_outlined), findsOneWidget);
  await tester.tap(find.byIcon(Icons.checklist_outlined));
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.text('Monthly'));
  await tester.pump();
  await tester.tap(find.text('Weekly'));
  await tester.pump();
  await tester.tapAt(const Offset(400, 0));
  await tester.pump();

  expect(find.text('(Monthly)'), findsOneWidget);
  (fsSelect as FsSelectionServiceMock).filePath =
      appDataPath + "/RBW-ChkRnHrs-M.pdf";
  await tester.dragFrom(
      tester.getTopLeft(find.byType(MaterialApp)), const Offset(300, 0));
  await tester.pumpAndSettle();
  expect(find.textContaining('Import'), findsOneWidget);
  await tester.tap(find.textContaining('Import'));
  await tester.pump(const Duration(seconds: 1));
  await tester.tapAt(const Offset(400, 0));
  await tester.enterText(find.byKey(const Key('SearchField')), 'cp');
  // await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump(const Duration(seconds: 1));
  // expect(find.byType(MeterWidget), findsNWidgets(4));
  await tester.pump(const Duration(seconds: 5));
}
