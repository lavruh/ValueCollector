import 'dart:io';

abstract class DataFromFileService {
  openFile(String filePath);
  List getMeters();
  List<Map> getMeterValues(String meterId);
  setMeterReading({
    required String meterId,
    required String val,
  });
  exportData();
}
