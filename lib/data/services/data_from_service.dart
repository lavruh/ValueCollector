import 'dart:io';

abstract class DataFromFileService {
  setFilePath(String filePath);
  openFile(String filePath);
  List getMeters();
  List<Map> getMeterValues(String meterId);
  setMeterReading({
    required String meterId,
    required String val,
  });
  exportData({String? outputPath});
}
