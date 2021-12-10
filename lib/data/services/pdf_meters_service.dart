import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:rh_collector/data/services/data_from_service.dart';

class PdfMetersService implements DataFromFileService {
  File? pdf;

  @override
  List getMeterValues(String meterId) {
    if (pdf != null) {}
    return [];
  }

  @override
  List getMeters() {
    if (pdf != null) {}
    return [];
  }

  @override
  openFile(String filePath) async {
    if (await File(filePath).exists()) {
      pdf = File(filePath);
      final PdfDocument document =
          PdfDocument(inputBytes: pdf?.readAsBytesSync());
      print(document);
    } else {
      throw Exception("File does not exist");
    }
  }

  @override
  void setMeterReading({
    required String meterId,
    required String val,
  }) {
    if (pdf != null) {}
  }
}
