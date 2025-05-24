import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:rh_collector/data/dtos/meter_dto.dart';
import 'package:rh_collector/data/dtos/meter_value_dto.dart';
import 'package:rh_collector/data/services/data_from_service.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';

class DataFromFileMock implements DataFromFileService {
  Map data = {};
  Map<String, dynamic> values = {};
  Map newValues = {};

  @override
  exportData({required String output, String? template}) {}

  @override
  setFilePath(String filePath) {}

  @override
  List<MeterValueDto> getMeterValues(String meterId) {
    if (values.keys.contains(meterId)) {
      return [MeterValueDto.fromMap(values[meterId])];
    }

    return [];
  }

  addFakeMeter({
    required Meter m,
    required MeterValue v,
  }) {
    data.putIfAbsent(m.id, () => MeterDto.fromDomain(m).toMap());
    values.putIfAbsent(m.id, () => MeterValueDto.fromDomain(v).toMap());
  }

  @override
  List<MeterDto> getMeters() {
    return data.values.map((e) => MeterDto.fromMap(e)).toList();
  }

  @override
  setMeterDataToExport({required MeterDto meterDto}) {
    // throw Exception(
    //     "Not applicable for this format, select template file instead");
  }

  @override
  openFile(String filePath) {}

  @override
  setMeterReading({
    required String meterId,
    required String val,
  }) {
    if (data.containsKey(meterId)) {
      newValues[meterId] = val;
    } else {
      throw Exception("File does not contain meter id[$meterId]");
    }
  }

  @override
  FileSystem fs = MemoryFileSystem();
}
