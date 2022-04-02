import 'dart:io';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:rh_collector/data/services/data_from_service.dart';

class PdfMetersService implements DataFromFileService {
  String? fPath;
  PdfDocument? document;
  Map pdfData = {};
  Map newValues = {};
  double outputLeft = 0;
  Rect _outputDateFieldPosition = Rect.fromLTWH(0, 0, 100, 50);
  DateTime dateOfReadings = DateTime.now();
  bool meterDetected = false;
  List<String> meter = [];
  Rect? pos;

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
    await setFilePath(filePath);
    File pdf = File(fPath!);
    document = PdfDocument(inputBytes: pdf.readAsBytesSync());
    parsePDF();
  }

  @override
  setFilePath(String filePath) async {
    if (await File(filePath).exists()) {
      fPath = filePath;
    } else {
      throw Exception("File does not exist");
    }
  }

  @override
  void setMeterReading({
    required String meterId,
    required String val,
  }) {
    newValues[meterId] = val;
  }

  parsePDF() {
    pdfData.clear();
    meterDetected = false;
    List<TextLine> lines = PdfTextExtractor(document!).extractTextLines();
    int page = 0;
    for (TextLine l in lines) {
      List<TextWord> words = l.wordCollection;
      for (TextWord word in words) {
        _detectAndSetOutputLeft(word);
        _detectAndSetDateOutput(word);
        if (_detectMeterDataStart(word.text)) {
          if (meterDetected == true) {
            _addPdfData(page);
          }
          page = l.pageIndex;
          _initMeterDataCollecting(word);
          continue;
        }
        if (meterDetected) {
          meter.add(word.text);
        }
      }
    }
    _addPdfData(page);
  }

  bool _detectMeterDataStart(String t) {
    return t.contains(RegExp(r'[A-Z]{4,}[0-9]{0,2}')) & !t.contains("HISTORY");
  }

  _addPdfData(int page) {
    if (meter.isNotEmpty) {
      pdfData.putIfAbsent(meter[0], () => processRawData(page: page));
    }
  }

  DateTime? _parseDate(String s) {
    DateTime? d;
    try {
      d = DateFormat("dd-M-yy").parse(s);
    } on Exception {
      // if record has no date use previous date
      // normally readings in file from same date
      d = dateOfReadings;
    }
    dateOfReadings = d;
    return d;
  }

  Map processRawData({
    required int page,
  }) {
    String _id = meter[0];
    DateTime? d;
    int l = meter.length;
    String name = "";
    int reading = 0;
    for (int i = 0; i < meter.length; i++) {
      String s = meter[i];
      if (_isDate(s)) {
        d = _parseDate(s);
        l = i;
      }
      if (_isReading(s)) {
        reading = _parseReading(s);
        break;
      }
    }
    for (int i = 5; i < l; i++) {
      name += meter[i];
    }
    return {
      "id": _id,
      "name": name.isNotEmpty ? name : _id,
      "date": d ?? dateOfReadings,
      "reading": reading,
      "rect": pos,
      "page": page,
    };
  }

  @override
  exportData({String? outputPath}) async {
    if (fPath == null) {
      throw Exception("No file to export selected");
    }
    document = null;
    await openFile(fPath!);
    int p = -1;
    for (Map m in pdfData.values) {
      if (p != m["page"]) {
        p = m["page"];
        document?.pages[p].graphics.drawString(
          DateFormat("y-MM-dd").format(DateTime.now()),
          PdfStandardFont(PdfFontFamily.helvetica, 9),
          bounds: _outputDateFieldPosition,
          brush: PdfBrushes.black,
        );
      }
      Rect? r = m["rect"];
      document?.pages[p].graphics.drawString(
        newValues[m["id"]] ?? "-",
        PdfStandardFont(PdfFontFamily.helvetica, 7),
        bounds: Rect.fromLTRB(outputLeft, r!.top, 100, 50),
        brush: PdfBrushes.black,
      );
    }
    if (outputPath != null) {
      File(outputPath).writeAsBytes(document!.save());
    } else {
      File(getExportPath()).writeAsBytes(document!.save());
    }
  }

  String getExportPath() {
    String out = fPath!.replaceFirst(r".pdf",
        "_" + DateFormat("y-M-d_hh:mm").format(DateTime.now()) + ".pdf");
    return out;
  }

  void _detectAndSetOutputLeft(TextWord word) {
    if (word.text.contains("New")) {
      outputLeft = word.bounds.left;
    }
  }

  void _detectAndSetDateOutput(TextWord word) {
    if (word.text.contains("Date:")) {
      Rect p = word.bounds;
      _outputDateFieldPosition = Rect.fromLTWH(p.left + 30, p.top - 5, 100, 0);
    }
  }

  void _initMeterDataCollecting(TextWord word) {
    meter.clear();
    meter.add(word.text);
    pos = word.bounds;
    meterDetected = true;
  }
}

int _parseReading(String s) {
  String readingStr = "";
  readingStr = s.substring(0, s.length - 3);
  readingStr = readingStr.replaceAll(RegExp(r','), "");
  return int.tryParse(readingStr) ?? 0;
}

bool _isReading(String s) {
  return s.contains(RegExp(r'\.00'));
}

bool _isDate(String s) {
  return s.contains(RegExp(r'\d{1,2}-\d{1,2}-\d{1,2}'));
}
