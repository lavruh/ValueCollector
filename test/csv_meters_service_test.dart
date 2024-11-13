import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:rh_collector/data/dtos/meter_dto.dart';
import 'package:rh_collector/data/services/csv_meters_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'csv_meters_service_test.mocks.dart';

const String inputFileData =
    "id,name,2022-07-13,2023-07-13\r\nAUXGENENG,aux,1,2\r\nMAINENGPS,ps me,2,3\r\nMAINENGSB,sb me,3,4\r\n";
const documentData = [
  ['id', 'name', '2022-07-13', '2023-07-13'],
  ['AUXGENENG', 'aux', 1, 2],
  ['MAINENGPS', 'ps me', 2, 3],
  ['MAINENGSB', 'sb me', 3, 4]
];

@GenerateNiceMocks([MockSpec<File>()])
void main() {
  late CsvMetersService service;
  late MockFile testFile;

  setUp(() {
    testFile = MockFile();
    service = CsvMetersService();
  });

  test('set file path', () async {
    const testPath = "/some/path.csv";
    when(testFile.exists()).thenAnswer((answ) async => true);
    when(testFile.path).thenAnswer((answ) => testPath);
    await service.setFilePath(testFile);
    expect(service.fPath, testPath);
  });

  test('set wrong file path', () async {
    const testPath = "/some/path.pdf";
    when(testFile.exists()).thenAnswer((answ) async => false);
    when(testFile.path).thenAnswer((answ) => testPath);
    expect(() async => await service.setFilePath(testFile), throwsException);
  });

  test('set wrong file extension', () async {
    const testPath = "/some/path.pdf";
    when(testFile.exists()).thenAnswer((answ) async => true);
    when(testFile.path).thenAnswer((answ) => testPath);
    expect(() async => await service.setFilePath(testFile), throwsException);
  });

  test('open file for parsing', () async {
    const testPath = "/some/path.csv";
    when(testFile.exists()).thenAnswer((answ) async => true);
    when(testFile.path).thenAnswer((answ) => testPath);
    when(testFile.readAsString())
        .thenAnswer((realInvocation) async => inputFileData);
    await service.openFile(testFile);
    expect(service.document.length, documentData.length);
    expect(service.document.first.length, documentData.first.length);
  });

  test('parse input data', () async {
    service.document = documentData;
    service.parseData();
    expect(service.meters.length, documentData.length - 1);
    expect(service.meters.keys, contains('AUXGENENG'));
    expect(service.meters.values, contains('aux'));
    expect(service.values.length, documentData.length - 1);
    expect(service.values.keys, contains('AUXGENENG'));
    expect(service.values['AUXGENENG']?.length, 2);
  });

  test('data structure in first row is correct', () {
    bool fl = true;
    try {
      service.checkDataStructureIsCorrect(documentData.first);
      fl = false;
    } on Exception {
      fl = true;
    }
    expect(fl, false);
  });

  test('data structure check throws exception on incorrect data', () {
    expect(() => service.checkDataStructureIsCorrect(documentData.last),
        throwsException);
  });

  test("get meters IDs and names", () {
    service.document = documentData;
    service.parseData();
    final result = service.getMeters();
    expect(result.length, documentData.length - 1);
  });

  test('get meter values', () {
    service.document = documentData;
    service.parseData();
    final result = service.getMeterValues("AUXGENENG");
    expect(result.length, documentData.last.length - 2);
  });

  test('set meter reading', () {
    service.values.putIfAbsent("AUXGENENG", () => {DateTime.now(): 1});
    service.setMeterReading(meterId: "AUXGENENG", val: "777");
    expect(service.values.keys, contains('AUXGENENG'));
    expect(service.values['AUXGENENG']?.values.last, 777);
  });

  test("set meter data trys to set not existing meter", () {
    expect(() => service.setMeterReading(meterId: "AUXGENENG", val: "777"),
        throwsException);
  });

  test("export data", () async {
    service.meters.putIfAbsent("AUXGENENG", () => "Auxilary Engine");
    service.meters.putIfAbsent("MAINENGPS", () => "PS main engine");
    service.values.putIfAbsent("AUXGENENG", () => {DateTime(2022, 2, 24): 1});
    service.values.putIfAbsent("MAINENGPS", () => {DateTime(2022, 2, 24): 2});
    service.setMeterReading(meterId: "AUXGENENG", val: "777");
    service.setMeterReading(meterId: "MAINENGPS", val: "123456");
    await service.exportData(output: testFile);
    final captured = verify(testFile.writeAsString(captureAny, flush: true)).captured;
    expect(captured.length, 1);
    expect(captured[0], contains('id,name,2022-02-24,'));
    expect(
        captured[0],
        contains(
            'AUXGENENG,Auxilary Engine,1,777\r\nMAINENGPS,PS main engine,2,123456'));
  });

  test("Set meter data (id and name) to export", () async {
    final testData = MeterDto(id: "someid", name: "metername");
    service.setMeterDataToExport(meterDto: testData);
    expect(service.meters.keys, contains(testData.id));
    expect(service.meters.values, contains(testData.name));
    expect(service.values.keys, contains(testData.id));
  });
}
