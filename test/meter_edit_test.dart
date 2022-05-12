import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rh_collector/di.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/ui/screens/meter_edit_screen.dart';
import 'package:rh_collector/ui/widgets/meter_value_edit_widget.dart';

main() {
  initDependenciesTest();
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
    expect(find.descendant(of: valWidget, matching: find.text("0")),
        findsNWidgets(2));
    // expect(meter.values.length, 1);
  });

  testWidgets("add second value", (WidgetTester tester) async {
    meter.addValue(MeterValue(DateTime(2022, 1, 1), 123));
    expect(meter.values.length, 1);
    await tester.pumpWidget(testableWidget(child: editor));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(MeterValueEditWidget), 2);
    expect(find.textContaining("123"), findsNWidgets(2));
    expect(
        find.descendant(
            of: find.byType(MeterValueEditWidget).last,
            matching: find.text("0")),
        findsNWidgets(2));
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

// Widget testableWidget({required Widget child}) {
//   return MediaQuery(
//     data: const MediaQueryData(),
//     child: GetMaterialApp(
//       home: Scaffold(body: child),
//     ),
//   );
// }

Widget testableWidget({Widget? child}) {
  final ThemeData _theme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.grey,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey))),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: "Georgia",
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
      headline2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      headline3: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
      headline6: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(fontSize: 12.0),
    ),
    // inputDecorationTheme: InputDecorationTheme(
    //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
  );

  return GetMaterialApp(
    theme: _theme,
    home: child,
  );
}
