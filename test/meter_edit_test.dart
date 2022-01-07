import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rh_collector/di.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/ui/screens/meter_edit_screen.dart';

main() {
  init_dependencies_test();
  Meter meter = Meter(name: "m1", groupId: "W");
  Widget editor = MeterEditScreen(meter: meter);

  setUp(() {
    meter = Meter(name: "m1", groupId: "W");
    editor = MeterEditScreen(meter: meter);
  });

  testWidgets("load widget", (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(child: editor));
    await tester.pump();

    expect(find.textContaining(meter.name), findsOneWidget);
    expect(find.textContaining("Correction"), findsOneWidget);
  });

  testWidgets("add value", (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(child: editor));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    final valWidget = find.ancestor(
        matching: find.byType(Wrap),
        of: find.textContaining(
          DateFormat("yyyy-MM-dd").format(DateTime.now()),
        ));
    final textField =
        find.descendant(of: valWidget, matching: find.byType(TextField));
    expect(valWidget, findsOneWidget);
    expect(textField, findsOneWidget);
    expect(find.descendant(of: valWidget, matching: find.text("0")),
        findsOneWidget);
    expect(
        find.descendant(
            of: valWidget, matching: find.byIcon(Icons.delete_forever)),
        findsOneWidget);
    expect(meter.values.length, 1);
  });

  testWidgets("add second value", (WidgetTester tester) async {
    meter.addValue(MeterValue(DateTime(2022, 1, 1), 123));
    await tester.pumpWidget(testableWidget(child: editor));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(meter.values.length, 2);
    expect(meter.values.first.value, 123);
    expect(meter.values.last.value, 0);
    expect(find.textContaining("2022"), findsNWidgets(2));
    expect(find.textContaining("123"), findsOneWidget);
    final valWidget = find.ancestor(
        matching: find.byType(Wrap),
        of: find.textContaining(
          DateFormat("yyyy-MM-dd").format(DateTime.now()),
        ));
    expect(valWidget, findsOneWidget);
    expect(find.descendant(of: valWidget, matching: find.text("0")),
        findsOneWidget);
  });

  testWidgets("Update value", (WidgetTester tester) async {
    meter.addValue(MeterValue(DateTime(2021, 1, 1), 123));
    await tester.pumpWidget(testableWidget(child: editor));
    await tester.pump();
    final valWidget = find.ancestor(
        matching: find.byType(Wrap),
        of: find.textContaining(
          DateFormat("yyyy-MM-dd").format(DateTime(2021, 1, 1)),
        ));
    expect(valWidget, findsOneWidget);
    await tester.enterText(
        find.descendant(of: valWidget, matching: find.byType(TextField)),
        "345");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(meter.values.first.value, 345);
    expect(meter.values.length, 1);
  });
}

Widget testableWidget({required Widget child}) {
  return MediaQuery(
    data: MediaQueryData(),
    child: GetMaterialApp(
      home: Scaffold(body: child),
    ),
  );
}
