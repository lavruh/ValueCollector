import 'package:rh_collector/data/services/csv_route_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file/memory.dart';

main() {
  MemoryFileSystem fs = MemoryFileSystem();
  final dir = fs.directory('test');
  dir.createSync(recursive: true);
  final testFile = fs.file('${dir.path}/weekly_route.csv');
  testFile.createSync();

  final service = CsvRouteService.test(fs);

  test('import weekly route', () async {
    String filePath = testFile.path;
    testFile.writeAsStringSync("""AUXGENENG\n\r
MAINENGPS\n\r
MAINENGSB\n\r
JETPUHPSB\n\r
JETPULP\n\r
JETPUHPPS\n\r
DREDPUENG\n\r
DREDPUENG2\n\r
BOWTH\n\r
UWPMOTOR\n\r
EMERGEN\n\r
""");
    List<String> result = await service.getMetersRoute(filePath);
    expect(result.length, 11);
  });

  test('import wrong file', () async {
    final wrongFile = fs.file('${dir.path}/w_route.pdf');
    wrongFile.createSync();
    String filePath = wrongFile.path;

    List<String> result = await service.getMetersRoute(filePath);
    expect(result, []);
  });
}
