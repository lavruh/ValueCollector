import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:rh_collector/ui/widgets/meters_groups_widget.dart';

import 'utils.dart';

//  """Open groups menu, add group,
// - edit new group, add extra group, delete new group  """;

Future<void> groupsMenuTest(WidgetTester tester) async {
  expect(readyToRun, true);
  await tester.pumpWidget(testableWidget(MetersGroupsWidget()));
  await tester.pump();
  expect(find.textContaining('Groups'), findsOneWidget);
  expect(find.textContaining('Weekly'), findsOneWidget);
  expect(find.textContaining('Monthly'), findsOneWidget);
  expect(find.byIcon(Icons.add), findsOneWidget);
  expect(find.byIcon(Icons.edit), findsOneWidget);
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  expect(find.byType(Checkbox), findsNWidgets(3));
  expect(find.textContaining('name'), findsOneWidget);
  await tester.tap(find.byIcon(Icons.edit));
  await tester.pump();
  expect(find.byIcon(Icons.delete), findsNWidgets(3));
  expect(find.byType(TextField), findsNWidgets(3));
  final field = find.textContaining('name');
  await tester.tap(field);
  await tester.enterText(field, 'NEW_GROUP');
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump();
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  expect(find.textContaining('name'), findsOneWidget);
  final tile = find.ancestor(
    of: find.textContaining('NEW_GROUP'),
    matching: find.byType(ListTile),
  );
  final deleteBut =
      find.descendant(of: tile, matching: find.byIcon(Icons.delete));
  expect(deleteBut, findsOneWidget);
  await tester.tap(deleteBut);
  await tester.pump();
  expect(find.textContaining('NEW_GROUP'), findsNothing);
}
