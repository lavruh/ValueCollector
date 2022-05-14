import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:rh_collector/app.dart';
import 'package:rh_collector/di.dart';
import 'package:rh_collector/ui/widgets/drawer_menu_widget.dart';

main() {
  appDataPath =
      "/home/lavruh/AndroidStudioProjects/RhCollector/test/integration_tests/testdata";
  initDependenciesTest();
  const app = App();
  testWidgets("init load", (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pump();

    expect(find.textContaining("Weekly"), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsOneWidget);

    await tester.dragFrom(
        tester.getTopLeft(find.byType(MaterialApp)), const Offset(300, 0));

    await tester.pumpAndSettle();
    expect(find.textContaining("Groups"), findsOneWidget);
    expect(find.textContaining("Routes"), findsOneWidget);
    expect(find.textContaining("Import"), findsOneWidget);
  }, skip: true);

  testWidgets("drawer menu", (WidgetTester tester) async {
    const menu = DrawerMenuWidget();
    await tester.pumpWidget(testableWidget(child: menu));
    await tester.pump();

    expect(find.textContaining("Groups"), findsOneWidget);
    expect(find.textContaining("Routes"), findsOneWidget);
    expect(find.textContaining("Import"), findsOneWidget);
  }, skip: true);
}

Widget testableWidget({required Widget child}) {
  return MediaQuery(
    data: const MediaQueryData(),
    child: GetMaterialApp(
      home: Scaffold(body: child),
    ),
  );
}
