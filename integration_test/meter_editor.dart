import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rh_collector/ui/screens/meters_screen.dart';
import 'package:rh_collector/ui/widgets/meter_value_edit_widget.dart';

import 'utils.dart';

// add new value, open editor, change name and unit,
// add value => correction is 0, date is now,
// save meter, check widget
// add value from camera, check widget, delta value is correct,
// open editor, change correction, save meter, add value from camera,
// open editor, check new value with correction, old values unchanged
// add value, check correction, delete value,
// delete dialog apears, cancel button works, ok button works,

Future<void> meterEditorTest(WidgetTester tester) async {
  expect(readyToRun, true);
  await tester.pumpWidget(testableWidget(const MetersScreen()));
  await tester.pump();
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  await tester.pump(const Duration(seconds: 5));
  expect(find.textContaining('new_meter'), findsOneWidget);
  await tester.tap(find.textContaining('new_meter'));
  await tester.pump();
  await tester.pump(const Duration(seconds: 5));
  expect(find.textContaining('new_meter'), findsOneWidget);
  expect(find.textContaining('Name'), findsOneWidget);
  expect(find.textContaining('Unit'), findsOneWidget);
  expect(find.textContaining('Correction'), findsOneWidget);
  expect(find.byIcon(Icons.add), findsOneWidget);
  expect(find.byIcon(Icons.check), findsOneWidget);
  expect(find.byIcon(Icons.delete_forever), findsOneWidget);
  const meterName = 'Meter Name';
  await tester.enterText(find.byKey(const Key('NameInput')), meterName);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump();
  const meterUnit = 'mm';
  await tester.enterText(find.byKey(const Key('UnitInput')), meterUnit);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump();

  await tester.tap(find.byIcon(Icons.add));
  await tester.pump(const Duration(seconds: 1));
  final dateString = DateFormat("yyyy-MM-dd").format(DateTime.now());
  expect(find.textContaining(dateString), findsOneWidget);
  expect(
      find.ancestor(
          of: find.text('0'), matching: find.byType(MeterValueEditWidget)),
      findsNWidgets(2));

  await tester.tap(find.byIcon(Icons.check));
  await tester.pump(const Duration(seconds: 1));
  expect(find.text(meterName), findsOneWidget);
  expect(find.text(meterUnit), findsOneWidget);
  expect(find.text('0'), findsOneWidget);
  expect(find.textContaining(dateString), findsOneWidget);
  const valFromCam = 123456;
  await moveToCamScreenAndSetVal(tester: tester, value: valFromCam.toString());
  await tester.pump(const Duration(seconds: 1));
  expect(find.textContaining(valFromCam.toString()), findsNWidgets(2));
  expect(find.textContaining(dateString), findsNWidgets(2));
  await tester.tap(find.textContaining(meterName));
  await tester.pump(const Duration(seconds: 1));
  const meterCorrection = 100;
  await tester.enterText(
      find.byKey(const Key('CorrectionInput')), meterCorrection.toString());
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump();
  await tester.tap(find.byIcon(Icons.check));
  await tester.pump(const Duration(seconds: 1));
  const valFromCam2 = 444;
  await moveToCamScreenAndSetVal(tester: tester, value: valFromCam2.toString());
  expect(find.textContaining((valFromCam2 + meterCorrection).toString()),
      findsOneWidget);
  expect(
      find.textContaining(
          (valFromCam2 + meterCorrection - valFromCam).toString()),
      findsOneWidget);
  await tester.tap(find.textContaining(meterName));
  await tester.pump(const Duration(seconds: 5));
  expect(
      find.descendant(
          of: find.byType(MeterValueEditWidget).first,
          matching: find.text(valFromCam2.toString())),
      findsOneWidget);
  expect(
      find.descendant(
          of: find.byType(MeterValueEditWidget).first,
          matching: find.text((valFromCam2 + meterCorrection).toString())),
      findsOneWidget);
  expect(find.textContaining(dateString), findsNWidgets(3));
  expect(
      find.descendant(
          of: find.byType(MeterValueEditWidget).last, matching: find.text('0')),
      findsNWidgets(2));
  expect(
      find.descendant(
          of: find.byType(MeterValueEditWidget).at(1),
          matching: find.text(valFromCam.toString())),
      findsNWidgets(2));

  await tester.drag(
      find.byType(MeterValueEditWidget).at(1), const Offset(-300, 0));
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 5));

  await tester.tap(find.descendant(
      of: find.byType(MeterValueEditWidget).at(1),
      matching: find.byIcon(Icons.delete_forever)));

  await tester.pump(const Duration(seconds: 1));

  expect(
      find.descendant(
          of: find.byType(MeterValueEditWidget).first,
          matching: find.text(valFromCam2.toString())),
      findsOneWidget);
  expect(
      find.descendant(
          of: find.byType(MeterValueEditWidget).first,
          matching: find.text((valFromCam2 + meterCorrection).toString())),
      findsOneWidget);
  expect(find.textContaining(dateString), findsNWidgets(2));
  expect(
      find.descendant(
          of: find.byType(MeterValueEditWidget).last, matching: find.text('0')),
      findsNWidgets(2));
  await tester.pump(const Duration(seconds: 5));
}
