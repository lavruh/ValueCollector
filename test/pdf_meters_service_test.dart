import 'dart:io';

import 'package:rh_collector/data/services/data_from_service.dart';
import 'package:rh_collector/data/services/pdf_meters_service.dart';
import 'package:test/test.dart';
import 'package:intl/intl.dart';

main() {
  const filePath =
      "/home/lavruh/AndroidStudioProjects/RhCollector/test/examples/RBW-ChkRnHrs-W.pdf";
  const filePathM =
      "/home/lavruh/AndroidStudioProjects/RhCollector/test/examples/RBW-ChkRnHrs-M.pdf";
  const file2Path =
      "/home/lavruh/AndroidStudioProjects/RhCollector/test/examples/RBW-ChkRnHrs-W02.pdf";

  DataFromFileService serv = PdfMetersService();

  tearDown(() {
    (serv as PdfMetersService).pdfData.clear();
  });

  test("open file", () async {
    await serv.openFile(filePath);
    expect((serv as PdfMetersService).document, isNotNull);
  });

  test("parse weekly pdf", () async {
    await serv.openFile(filePath);
    Map res = (serv as PdfMetersService).pdfData;

    expect((serv as PdfMetersService).document, isNotNull);
    expect(res, isNotEmpty);
    expect(res, hasLength(11));
    expect(res['DREDPUENG2']['id'], 'DREDPUENG2');
    expect(res['DREDPUENG2']['name'], 'E-Motor, Dredge Pump, SB');
    expect(res['DREDPUENG2']['date'], DateTime(2021, 11, 27));
    expect(res['DREDPUENG2']['reading'], 20873);

    await serv.openFile(file2Path);
    res = (serv as PdfMetersService).pdfData;
    expect(res['MAINENGSB']['id'], 'MAINENGSB');
    expect(res['MAINENGSB']['name'], 'Main Engine, SB');
    expect(res['MAINENGSB']['date'], DateTime(2021, 12, 18));
    expect(res['MAINENGSB']['reading'], 149208);
    expect((serv as PdfMetersService).outputLeft, greaterThanOrEqualTo(400));
  });

  test("parse monthly pdf", () async {
    await serv.openFile(filePathM);
    Map res = (serv as PdfMetersService).pdfData;
    expect((serv as PdfMetersService).document, isNotNull);
    expect(res, isNotEmpty);
    expect(res, hasLength(105)); //May be wrong correct value
    expect(res['PMPLJGLP']['id'], 'PMPLJGLP');
    expect(res['PMPLJGLP']['date'], DateTime(2021, 12, 1));
    expect(res['PMPLJGLP']['reading'], 64032);
    expect(
        res['INTMDWCHS2']['name'], 'Intermediate Winch, Extended Trail Pipe');
    expect(res['PMPTRHS2PS']['name'], 'Pump, Transfer, Hydraulic System, PS');
    expect((serv as PdfMetersService).outputLeft, greaterThanOrEqualTo(400));
  });

  test("get meters", () async {
    await serv.openFile(filePath);
    List res = serv.getMeters();
    expect(res.length, 11);
    expect(
        res.indexWhere((element) => element["id"] == 'MAINENGSB') > -1, true);
  });

  test("get values", () async {
    await serv.openFile(filePath);
    List<Map> res = serv.getMeterValues('MAINENGSB');
  });

  test("set new value", () async {
    await serv.openFile(filePath);
    List data = serv.getMeters();
    String id = data.first["id"];
    int newVal = 123;
    serv.setMeterReading(meterId: id, val: newVal.toString());
    Map res = (serv as PdfMetersService).pdfData;
    expect(res[id]["newValue"], newVal.toString());
  });

  test("export values", () async {
    await serv.openFile(filePath);
    List data = serv.getMeters();
    for (Map i in data) {
      serv.setMeterReading(meterId: i["id"], val: i["reading"]);
    }
    String sufix = "_" + DateFormat("y-M-d_hh:mm").format(DateTime.now());
    String newFilePath =
        "/home/lavruh/AndroidStudioProjects/RhCollector/test/examples/RBW-ChkRnHrs-W$sufix.pdf";

    await serv.exportData();

    expect(File(newFilePath).existsSync(), true);
  }, skip: "creating files");

  test("export monthly", () async {
    await serv.openFile(filePathM);
    List data = serv.getMeters();
    for (Map i in data) {
      serv.setMeterReading(meterId: i["id"], val: i["reading"]);
    }
    String sufix = "_" + DateFormat("y-M-d_hh:mm").format(DateTime.now());
    String newFilePath =
        "/home/lavruh/AndroidStudioProjects/RhCollector/test/examples/RBW-ChkRnHrs-W$sufix.pdf";

    await serv.exportData();

    expect(File(newFilePath).existsSync(), true);
  }, skip: "");

  test("correct export file name", () {
    String sufix = "_" + DateFormat("y-M-d_hh:mm").format(DateTime.now());
    String newFilePath =
        "/home/lavruh/AndroidStudioProjects/RhCollector/test/examples/RBW-ChkRnHrs-W$sufix.pdf";

    serv.openFile(filePath);
    String r = (serv as PdfMetersService).getExportPath();

    expect(r, newFilePath);
  });
}
