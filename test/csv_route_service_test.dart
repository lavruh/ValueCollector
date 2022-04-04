import 'package:rh_collector/data/services/csv_route_service.dart';
import 'package:test/test.dart';

main() {
  final service = CsvRouteService();
  test('import weekly route', () async {
    String filePath =
        "/home/lavruh/AndroidStudioProjects/RhCollector/test/examples/weekly_route.csv";
    List<String> result = await service.getMetersRoute(filePath);
    expect(result.length, 11);
  });

  test('import wrong file', () async {
    String filePath =
        "/home/lavruh/AndroidStudioProjects/RhCollector/test/examples/RBW-ChkRnHrs-M.pdf";
    expect(() => service.getMetersRoute(filePath), throwsException);
  });
}
