import 'package:rh_collector/data/dtos/meter_dto.dart';
import 'package:rh_collector/data/services/data_from_service.dart';
import 'package:rh_collector/data/services/pdf_meters_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:file/memory.dart';
import 'pdf_meters_data.dart';
import 'pdf_meters_data2.dart';
import 'pdf_meters_data3.dart';

main() {
  const filePath = "RBW-ChkRnHrs-W.pdf";
  const filePathM = "RBW-ChkRnHrs-M.pdf";
  const file2Path = "RBW-ChkRnHrs-W02.pdf";

  final fs = MemoryFileSystem();
  DataFromFileService serv = PdfMetersService.test(fs);
  fs.file(filePath).writeAsBytes(file1data);
  fs.file(filePathM).writeAsBytes(pdfDataM);
  fs.file(file2Path).writeAsBytes(pdfDataW2);

  final fileWeeklyReport = fs.file(filePath);

  tearDown(() {
    (serv as PdfMetersService).pdfData.clear();
  });

  test("open file", () async {
    await serv.openFile(fileWeeklyReport.path);
    expect((serv as PdfMetersService).pdfData, isNotEmpty);
  });

  test("parse weekly pdf", () async {
    await serv.openFile(fileWeeklyReport.path);
    Map res = (serv as PdfMetersService).pdfData;

    expect(res, isNotEmpty);
    expect(res, hasLength(11));
    expect(res['DREDPUENG2']['id'], 'DREDPUENG2');
    expect(res['DREDPUENG2']['name'], 'E-Motor, Dredge Pump, SB');
    expect(res['DREDPUENG2']['date'], DateTime(2021, 11, 27));
    expect(res['DREDPUENG2']['reading'], 20873);

    await serv.openFile(file2Path);
    res = serv.pdfData;
    expect(res['MAINENGSB']['id'], 'MAINENGSB');
    expect(res['MAINENGSB']['name'], 'Main Engine, SB');
    expect(res['MAINENGSB']['date'], DateTime(2022, 1, 8));
    expect(res['MAINENGSB']['reading'], 149404);
    expect(res['BOWTH']['page'], 0);
    expect(serv.outputLeft, greaterThanOrEqualTo(400));

    for (var e in res.values) {
      expect(e['name'], isNotEmpty);
      expect(e['date'], isNotNull);
      expect(e['rect'], isNotNull);
      expect(e['page'], isNotNull);
    }
  });

  test("parse monthly pdf", () async {
    await serv.openFile(filePathM);
    Map res = (serv as PdfMetersService).pdfData;
    expect(res, isNotEmpty);
    expect(res['PMPLJGLP']['id'], 'PMPLJGLP');
    expect(res['PMPLJGLP']['date'], DateTime(2021, 12, 1));
    expect(res['PMPLJGLP']['reading'], 64032);
    expect(
        res['INTMDWCHS2']['name'], 'Intermediate Winch, Extended Trail Pipe');
    expect(res['PMPTRHS2PS']['name'], 'Pump, Transfer, Hydraulic System, PS');

    expect(res['LOSEPMES1']['name'], contains("Separator,"));
    expect(res['COMPREF03']['name'], contains("Refrigeration"));
    expect(res['COMPREF03']['page'], 1);
    expect(res['COMPREF04']['name'], contains("Refrigeration"));
    expect(res['PMPFOTHOL1']['name'], contains("Fuel"));
    expect(res['PMPFOTHOL2']['name'], contains("Fuel"));
    expect(res['PMPCOTHYS1']['name'], contains("Pumpset"));
    expect(res['PMPCOTHYS1']['page'], 3);
    expect(res['PMPFLACT1']['name'], contains("EM4"));
    expect(res['PMPOWFIL1']['name'], contains("Filtering"));
    expect(res['PMPHEACOO1']['name'], contains("Cooling"));
    expect(res['PMPPHME']['name'], contains("HT"));
    expect(res['PMPPHME']['page'], 4);
    expect(res['VISTHFO']['name'], contains("Viscositiy"));

    expect(res['DRHDWNCHPS']['page'], 0);
    expect(res['PMPLODPM05']['page'], 1);
    expect(res['PMPLT05']['page'], 2);
    expect(res['PMPHYCPSB2']['page'], 3);
    expect(res['VISTHFO']['page'], 4);
    expect(res, hasLength(105)); //May be wrong correct value

    for (var e in res.values) {
      expect(e['name'], isNotEmpty);
      expect(e['date'], isNotNull);
      expect(e['rect'], isNotNull);
      expect(e['page'], isNotNull);
    }
    expect(serv.outputLeft, greaterThanOrEqualTo(400));
  });

  test("get meters", () async {
    await serv.openFile(filePath);
    List<MeterDto> res = serv.getMeters();
    expect(res.length, 11);
    expect(res.indexWhere((element) => element.id == 'MAINENGSB') > -1, true);
  });

  test("set new value", () async {
    await serv.openFile(filePath);
    final data = serv.getMeters();
    String id = data.first.id;
    int newVal = 123;
    serv.setMeterReading(meterId: id, val: newVal.toString());
    Map res = (serv as PdfMetersService).newValues;
    expect(res[id], newVal.toString());
  });

  test("export values", () async {
    await serv.openFile(filePath);
    final data = serv.getMeters();
    int counter = 1;
    for (MeterDto i in data) {
      serv.setMeterReading(meterId: i.id, val: counter.toString());
      counter++;
    }
    String sufix = "_${DateFormat("y-M-d_hh:mm").format(DateTime.now())}";
    String newFilePath = "RBW-ChkRnHrs-W$sufix.pdf";

    await serv.exportData(output: newFilePath, template: filePath);

    expect(fs.file(newFilePath).existsSync(), true);
  });

  test("export monthly", () async {
    await serv.openFile(filePathM);
    final data = serv.getMeters();
    for (final i in data) {
      serv.setMeterReading(meterId: i.id, val: "123");
    }
    String sufix = "_${DateFormat("y-M-d_hh:mm").format(DateTime.now())}";
    String newFilePath = "RBW-ChkRnHrs-M$sufix.pdf";

    await serv.exportData(output: newFilePath, template: filePathM);

    expect(fs.file(newFilePath).existsSync(), true);
  });

  test("correct export file name", () {
    String sufix = "_${DateFormat("y-M-d_hh:mm").format(DateTime.now())}";
    String newFilePath = "RBW-ChkRnHrs-M$sufix.pdf";

    serv.openFile(filePath);
    String r = (serv as PdfMetersService).getExportPath();

    expect(r, newFilePath);
  });
}
