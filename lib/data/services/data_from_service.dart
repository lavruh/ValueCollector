import 'dart:io';

import 'package:rh_collector/data/dtos/meter_dto.dart';
import 'package:rh_collector/data/dtos/meter_value_dto.dart';

abstract class DataFromFileService {
  setFilePath(File filePath);
  openFile(File filePath);
  List<MeterDto> getMeters();
  List<MeterValueDto> getMeterValues(String meterId);
  setMeterReading({
    required String meterId,
    required String val,
  });
  exportData({required File output, File? template});
  setMeterDataToExport({required MeterDto meterDto});
}
