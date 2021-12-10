import 'dart:io';

abstract class DataFromFileService {
  openFile(String filePath);
  List getMeters();
  List getMeterValues(String meterId);
  setMeterReading({
    required String meterId,
    required String val,
  });
}
