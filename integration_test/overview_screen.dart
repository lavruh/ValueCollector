import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:rh_collector/ui/screens/meters_screen.dart';

import 'utils.dart';

//  """load app on overview screen,
// add meter, open menu, tap groups
// change group  """;

Future<void> overviewScreenTest(WidgetTester tester) async {
  expect(readyToRun, true);
  await tester.pumpWidget(testableWidget(const MetersScreen()));
  await tester.pump();
  expect(find.textContaining('Weekly'), findsOneWidget);
  expect(find.byIcon(Icons.add), findsOneWidget);
  expect(find.byIcon(Icons.close_outlined), findsOneWidget);
  expect(find.byIcon(Icons.checklist_outlined), findsOneWidget);
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  expect(find.textContaining('new_meter'), findsOneWidget);
  expect(find.byIcon(Icons.add_a_photo_outlined), findsOneWidget);
  await tester.dragFrom(
      tester.getTopLeft(find.byType(MaterialApp)), const Offset(300, 0));
  await tester.pumpAndSettle();
  expect(find.textContaining('Routes'), findsOneWidget);
  expect(find.textContaining('Groups'), findsOneWidget);
  expect(find.textContaining('Notifications'), findsOneWidget);
  expect(find.textContaining('Import'), findsOneWidget);
  expect(find.textContaining('Export'), findsOneWidget);
  await tester.tap(find.textContaining('Groups'));
  await tester.pumpAndSettle();
  expect(find.textContaining('Groups :'), findsOneWidget);
  final tileWeekly = find.ancestor(
    of: find.textContaining('Weekly'),
    matching: find.byType(ListTile),
  );
  final tileMonthly = find.ancestor(
    of: find.textContaining('Monthly'),
    matching: find.byType(ListTile),
  );
  expect(tileWeekly, findsOneWidget);
  expect(tileMonthly, findsOneWidget);
  await tester.tap(find.descendant(
    of: tileMonthly,
    matching: find.byType(Checkbox),
  ));
  await tester.pump();
  expect(find.textContaining('Monthly)'), findsOneWidget);
  await tester.tap(find.descendant(
    of: tileWeekly,
    matching: find.byType(Checkbox),
  ));
  await tester.pump();
  expect(find.textContaining('new_meter'), findsNothing);
}
