import 'package:file/local.dart';
import 'package:file/file.dart';
import 'package:rh_collector/data/dtos/meter_dto.dart';
import 'package:rh_collector/data/dtos/meter_value_dto.dart';

abstract class DataFromFileService {
  final FileSystem fs;
  DataFromFileService() : fs = const LocalFileSystem();
  setFilePath(String filePath);
  openFile(String filePath);
  List<MeterDto> getMeters();
  List<MeterValueDto> getMeterValues(String meterId);
  setMeterReading({
    required String meterId,
    required String val,
  });
  exportData({required String output, String? template});
  setMeterDataToExport({required MeterDto meterDto});
}
