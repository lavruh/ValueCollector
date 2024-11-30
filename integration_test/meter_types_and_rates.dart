import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:rh_collector/ui/screens/meters_screen.dart';

import 'utils.dart';

/// Open drawer menu tap on meter types
/// find "Running hours" type, add extra type, rename it change icon and color.
/// Add extra type, and delete it.
/// Go back, tap Meter rates, add rate, change type to created, check icon and color
/// change date range,check existing limit-price, change limit-pice, add limit price
/// delete limit, delete rate
Future<void> typesAndRatesScreen(WidgetTester tester) async {
  expect(readyToRun, true);
  await tester.pumpWidget(testableWidget(const MetersScreen()));
  await tester.pump();
  await tester.dragFrom(
      tester.getTopLeft(find.byType(MaterialApp)), const Offset(300, 0));
  await tester.pumpAndSettle();
  const lableText = 'Meter types';
  await tester.tap(find.textContaining(lableText));
  await tester.pumpAndSettle();
  expect(find.textContaining(lableText), findsOneWidget);
  expect(find.text('Name'), findsOneWidget);
  expect(find.text('Running hours'), findsOneWidget);
  expect(find.byIcon(Icons.electric_meter), findsOneWidget);
  expect(find.byIcon(Icons.color_lens), findsWidgets);
  expect(find.byIcon(Icons.add), findsOneWidget);
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  expect(find.textContaining('name'), findsOneWidget);
  const typeName = 'Meter type';
  await tester.enterText(find.byType(TextFormField).last, typeName);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump();
  await tester.tap(find.byIcon(Icons.electric_meter).last);
  await tester.pump();
  await tester.tap(find.byIcon(Icons.bolt).last);
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  expect(find.byType(Card), findsNWidgets(3));
  await tester.drag(find.byType(Card).last, const Offset(-300, 0));
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.delete_forever));
  await tester.pumpAndSettle();
  expect(find.byType(Card), findsNWidgets(2));
  await tester.tap(find.byTooltip('Back'));
  await tester.pumpAndSettle();
  await tester.tap(find.textContaining('Meter rates'));
  await tester.pumpAndSettle();
  expect(find.textContaining('Meter rates'), findsOneWidget);
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  expect(find.textContaining('Running hours'), findsOneWidget);
  final year = DateTime.now().year.toString();
  expect(find.textContaining(year), findsOneWidget);
  expect(find.textContaining('0 - 1.0'), findsOneWidget);
  final addLimit = find.descendant(
      of: find.byType(ActionChip), matching: find.byIcon(Icons.add));
  expect(addLimit, findsOneWidget);
  await tester.tap(find.textContaining('Running hours'));
  await tester.pumpAndSettle();
  expect(find.textContaining(typeName), findsWidgets);
  await tester.tap(find.textContaining(typeName).last);
  await tester.pumpAndSettle();
  await tester.tap(find.textContaining('0 - '));
  await tester.pumpAndSettle();
  expect(find.textContaining('Limit'), findsNWidgets(2));
  expect(find.textContaining('Price'), findsNWidgets(2));
  await tester.enterText(find.byKey(const Key('inputLimit')).last, "");
  await tester.tap(find.textContaining('Yes'));
  await tester.pumpAndSettle();
  expect(find.textContaining('Please enter some text'), findsOneWidget);
  await tester.enterText(find.byKey(const Key('inputLimit')).last, "-1");
  await tester.tap(find.textContaining('Yes'));
  await tester.pumpAndSettle();
  expect(find.textContaining('Value should be'), findsOneWidget);
  await tester.enterText(find.byKey(const Key('inputLimit')).last, "10");
  await tester.enterText(find.byKey(const Key('inputPrice')).last, "");
  await tester.tap(find.textContaining('Yes'));
  await tester.pumpAndSettle();
  expect(find.textContaining('Please enter some text'), findsOneWidget);
  await tester.enterText(find.byKey(const Key('inputPrice')).last, "1.1");
  await tester.tap(find.textContaining('Yes'));
  await tester.pumpAndSettle();
  expect(find.textContaining('10 - 1.1'), findsOneWidget);
  await tester.tap(find.descendant(
      of: find.byType(ActionChip), matching: find.byIcon(Icons.add)));
  await tester.pumpAndSettle();
  expect(find.textContaining('1.0'), findsOneWidget);
  expect(find.byType(ActionChip), findsNWidgets(4));
  await tester.longPress(find.textContaining('1.0'));
  await tester.pumpAndSettle();
  expect(find.byType(ActionChip), findsNWidgets(3));
}
