import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:rh_collector/ui/screens/meters_screen.dart';

import 'utils.dart';

// Notifications screen open, add notification, change name , edit month,
// save button appears and disapears on every change, date, time, repeat, weekday,
// clear content works, set weekday and repeat, save notification,
// add extra notification, go back,
// open notifications again => unsaved notification is not present
// delete dialog apears, cancel button works, ok button remove notification

Future<void> notificationScreenTest(WidgetTester tester) async {
  expect(readyToRun, true);
  await tester.pumpWidget(testableWidget(const MetersScreen()));
  await tester.pump();
  await tester.dragFrom(
      tester.getTopLeft(find.byType(MaterialApp)), const Offset(300, 0));
  await tester.pumpAndSettle();
  expect(find.textContaining('Reminders'), findsOneWidget);
  await tester.tap(find.textContaining('Reminders'));
  await tester.pump(const Duration(seconds: 1));
  expect(find.textContaining('Reminders'), findsOneWidget);
  expect(find.byIcon(Icons.add), findsOneWidget);
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump(const Duration(seconds: 1));
  expect(find.textContaining('Name'), findsOneWidget);
  expect(find.text('M'), findsOneWidget);
  expect(find.textContaining('D'), findsOneWidget);
  expect(find.textContaining('h:m'), findsOneWidget);
  expect(find.textContaining('Repeat'), findsOneWidget);
  expect(find.textContaining('Mon'), findsOneWidget);
  expect(find.textContaining('Tue'), findsOneWidget);
  expect(find.textContaining('Wed'), findsOneWidget);
  expect(find.textContaining('Thu'), findsOneWidget);
  expect(find.textContaining('Fri'), findsOneWidget);
  expect(find.textContaining('Sat'), findsOneWidget);
  expect(find.textContaining('Sun'), findsOneWidget);
  expect(find.byIcon(Icons.calendar_month), findsOneWidget);
  expect(find.byIcon(Icons.alarm), findsOneWidget);
  expect(find.byIcon(Icons.delete), findsOneWidget);
  expect(find.byIcon(Icons.clear_all), findsOneWidget);
  expect(find.byType(Checkbox), findsOneWidget);
  final input = find.byType(TextField);
  expect(input, findsOneWidget);
  const reminderName = 'Monthly Reminder';
  await tester.enterText(input, reminderName);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump(const Duration(seconds: 1));
  await checkReminderSaveAction(tester: tester);

  await checkDate(f: 'M', tester: tester, fndr: find.byIcon(Icons.check));
  await checkDate(f: 'D', tester: tester, fndr: find.byIcon(Icons.check));
  await checkDate(f: 'h:m', tester: tester, fndr: find.textContaining('OK'));
  final repeatChk = find.byType(Checkbox);
  expect(tester.firstWidget<Checkbox>(repeatChk).value, false);
  await tester.tap(repeatChk);
  await tester.pump(const Duration(seconds: 1));
  expect(tester.firstWidget<Checkbox>(repeatChk).value, true);
  await checkReminderSaveAction(tester: tester);
  await checkReminderWeekday(s: 'Mon', tester: tester);
  await checkReminderWeekday(s: 'Tue', tester: tester);
  await checkReminderWeekday(s: 'Wed', tester: tester);
  await checkReminderWeekday(s: 'Thu', tester: tester);
  await checkReminderWeekday(s: 'Fri', tester: tester);
  await checkReminderWeekday(s: 'Sat', tester: tester);
  await checkReminderWeekday(s: 'Sun', tester: tester);
  await tester.tap(find.byIcon(Icons.clear_all));
  await tester.pump(const Duration(seconds: 1));
  expect(find.text('M'), findsOneWidget);
  expect(find.textContaining('D'), findsOneWidget);
  expect(find.textContaining('h:m'), findsOneWidget);
  final widget = tester.firstWidget<ActionChip>(find.ancestor(
    of: find.text('Sun'),
    matching: find.byType(ActionChip),
  ));
  expect(widget.side, const BorderSide(width: 0));
  await tester.tap(find.text('Sun'));
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.byIcon(Icons.save));
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.byTooltip('Back'));
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(find.textContaining('Reminders'));
  await tester.pump(const Duration(seconds: 1));
  expect(find.text(reminderName), findsOneWidget);
  expect(find.text('Mon'), findsOneWidget);
  expect(
      tester
          .firstWidget<ActionChip>(find.ancestor(
            of: find.text('Sun'),
            matching: find.byType(ActionChip),
          ))
          .side,
      const BorderSide(width: 3));

  await tester.tap(find.byIcon(Icons.delete));
  await tester.pump();
  expect(find.textContaining('delete'), findsOneWidget);
  expect(find.text('Yes'), findsOneWidget);
  expect(find.text('No'), findsOneWidget);
  await tester.tap(find.text('No'));
  await tester.pump();
  expect(find.text(reminderName), findsOneWidget);
  await tester.tap(find.byIcon(Icons.delete));
  await tester.pump();
  await tester.tap(find.text('Yes'));
  await tester.pump();
  expect(find.text(reminderName), findsNothing);
}
