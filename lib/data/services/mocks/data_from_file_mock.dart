import 'dart:io';

import 'package:rh_collector/data/dtos/meter_dto.dart';
import 'package:rh_collector/data/dtos/meter_value_dto.dart';
import 'package:rh_collector/data/services/data_from_service.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';

class DataFromFileMock implements DataFromFileService {
  Map data = {};
  Map newValues = {};

  @override
  exportData({required File output, File? template}) {}

  @override
  setFilePath(File filePath) {}

  @override
  List<MeterValueDto> getMeterValues(String meterId) {
    List<Map> output = [];
    if (data.isNotEmpty) {
      output.add(data[meterId]);
    }
    return [];
  }

  addFakeMeter({
    required Meter m,
    required MeterValue v,
  }) {
    data.putIfAbsent(
        m.id,
        () => {
              "id": m.id,
              "name": m.name,
              "date": v.date,
              "reading": v.value,
              "rect": "",
              "page": 0,
            });
  }

  @override
  List<MeterDto> getMeters() {
    return data.values.map((e) => MeterDto.fromMap(e)).toList();
  }

  @override
  setMeterDataToExport({required MeterDto meterDto}) {
    throw Exception(
        "Not applicable for this format, select template file instead");
  }

  @override
  openFile(File filePath) {}

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
}
