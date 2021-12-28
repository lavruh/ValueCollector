import 'dart:io';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:rh_collector/data/services/data_from_service.dart';

class PdfMetersService implements DataFromFileService {
  File? pdf;
  PdfDocument? document;
  Map pdfData = {};
  double outputLeft = 0;
  Rect outputDate = Rect.fromLTWH(0, 0, 100, 50);

  @override
  List<Map> getMeterValues(String meterId) {
    List<Map> output = [];
    if (pdfData.isNotEmpty) {
      output.add(pdfData[meterId]);
    }
    return output;
  }

  @override
  List getMeters() {
    List result = [];
    if (pdfData.isNotEmpty) {
      result = pdfData.values.toList();
    }
    return result;
  }

  @override
  openFile(String filePath) async {
    if (await File(filePath).exists()) {
      pdf = File(filePath);
      document = PdfDocument(inputBytes: pdf?.readAsBytesSync());
      parsePDF();
    } else {
      throw Exception("File does not exist");
    }
  }

  @override
  void setMeterReading({
    required String meterId,
    required String val,
  }) {
    if (pdfData.containsKey(meterId)) {
      pdfData[meterId]["newValue"] = val;
    } else {
      throw Exception("File does not contain meter id[$meterId]");
    }
  }

  parsePDF() {
    pdfData.clear();
    List<TextLine> lines = PdfTextExtractor(document!).extractTextLines();

    for (TextLine l in lines) {
      List<TextWord> words = l.wordCollection;
      List<String> meter = [];
      Rect? pos;
      for (int j = 0; j < words.length; j++) {
        String t = words[j].text;
        if (t.contains("New")) {
          Rect p = words[j].bounds;
          outputLeft = p.left;
        }
        if (t.contains("Date:")) {
          Rect p = words[j].bounds;
          outputDate = Rect.fromLTWH(p.left + 30, p.top - 5, 100, 0);
        }
        if (t.contains(RegExp(r'[A-Z]{4,}'))) {
          meter.add(t);
          pos = words[j].bounds;
          continue;
        }
        if (meter.isNotEmpty) {
          meter.add(t);
        }
      }
      if (meter.isNotEmpty) {
        var v = pdfData.putIfAbsent(meter[0],
            () => processRawData(meter: meter, pos: pos, page: l.pageIndex));
      }
    }
  }

  Map processRawData({
    required List<String> meter,
    Rect? pos,
    required int page,
  }) {
    int l = getEndOfRawDataString(meter);
    String name = "";

    for (int i = 5; i < l - 2; i++) {
      name += meter[i];
    }

    return {
      "id": meter[0],
      "name": name,
      "date": meter[l - 2],
      "reading": meter[l - 1],
      "rect": pos,
      "page": page,
    };
  }

  int getEndOfRawDataString(List<String> meter) {
    int l = meter.length;
    for (int i = l; i > 3; i--) {
      if (meter[i - 1].contains(RegExp(r'\d{2,}'))) {
        l = i;
        break;
      }
    }
    return l;
  }

  @override
  exportData() {
    int p = -1;
    for (Map m in pdfData.values) {
      if (p != m["page"]) {
        p = m["page"];
        document?.pages[p].graphics.drawString(
          DateFormat("y-M-dd").format(DateTime.now()),
          PdfStandardFont(PdfFontFamily.helvetica, 9),
          bounds: outputDate,
          brush: PdfBrushes.black,
        );
      }

      Rect? r = m["rect"];
      document?.pages[p].graphics.drawString(
        m["newValue"],
        PdfStandardFont(PdfFontFamily.helvetica, 7),
        bounds: Rect.fromLTRB(outputLeft, r!.top, 100, 50),
        brush: PdfBrushes.black,
      );
    }
    File(getExportPath()).writeAsBytes(document!.save());
  }

  String getExportPath() {
    String out = pdf!.path.replaceFirst(r".pdf",
        "_" + DateFormat("y-M-d_hh:mm").format(DateTime.now()) + ".pdf");
    return out;
  }
}
