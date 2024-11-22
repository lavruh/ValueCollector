import 'package:file/local.dart';
import 'package:file/file.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:rh_collector/data/dtos/meter_dto.dart';
import 'package:rh_collector/data/dtos/meter_value_dto.dart';

import 'package:rh_collector/data/services/data_from_service.dart';

class CsvMetersService implements DataFromFileService {
  @override
  final FileSystem fs;
  CsvMetersService() : fs = const LocalFileSystem();
  CsvMetersService.test(FileSystem fileSystem) : fs = fileSystem;

  String? fPath;
  List<List> document = [];
  //{id, name}
  Map<String, String> meters = {};
  // {id, [{date, value}]}
  Map<String, Map<DateTime, int>> values = {};

  @override
  exportData({required String output, String? template}) async {
    List<List> data = [
      ['id', 'name']
    ];
    int j = 0;
    for (String meterId in meters.keys) {
      List meter = [meterId, meters[meterId]];
      for (DateTime readingId in values[meterId]!.keys) {
        final readings = values[meterId];
        if (j == 0) {
          data[0].add(DateFormat("yyyy-MM-dd").format(readingId));
        }
        meter.add(readings![readingId]);
      }
      j++;
      data.add(meter);
    }
    final res = const ListToCsvConverter().convert(data);
    final outFile = fs.file(output);
    await outFile.writeAsString(res, flush: true);
  }

  @override
  List<MeterValueDto> getMeterValues(String meterId) {
    if (values.containsKey(meterId)) {
      return values[meterId]!
          .entries
          .map((e) => MeterValueDto(
                date: e.key,
                value: e.value,
              ))
          .toList();
    } else {
      return [];
    }
  }

  @override
  List<MeterDto> getMeters() {
    return meters.entries
        .map((e) => MeterDto(id: e.key, name: e.value))
        .toList();
  }

  @override
  openFile(String filePath) async {
    try {
      setFilePath(filePath);
      final file = fs.file(filePath);
      final input = await file.readAsString();
      document = const CsvToListConverter().convert(input, fieldDelimiter: ',');
      parseData();
    } on Exception catch (e) {
      throw Exception("Can not open file. $e");
    }
  }

  @override
  setFilePath(String filePath) async {
    final file = fs.file(filePath);
    if (await file.exists()) {
      String path = file.path;
      if (path.endsWith('.csv')) {
        fPath = file.path;
      } else {
        throw Exception("Not correct file extension");
      }
    } else {
      throw Exception("File does not exist");
    }
  }

  @override
  setMeterReading({required String meterId, required String val}) {
    if (values.containsKey(meterId)) {
      values[meterId]?.putIfAbsent(DateTime.now(), () => int.parse(val));
    } else {
      throw Exception(
          "Meter with id => $meterId is not present in file [$fPath]");
    }
  }

  @override
  setMeterDataToExport({required MeterDto meterDto}) {
    meters.putIfAbsent(meterDto.id, () => meterDto.name);
    values.putIfAbsent(meterDto.id, () => {});
  }

  parseData() {
    List<DateTime> dates = [];
    for (int i = 0; i < document.length; i++) {
      final row = document[i];
      if (i == 0) {
        checkDataStructureIsCorrect(row);
        dates = getValueDates(row);
        continue;
      } else {
        meters.putIfAbsent(row[0], () => row[1]);
        Map<DateTime, int> tmpValues = {};
        for (int j = 2; j < row.length; j++) {
          tmpValues.putIfAbsent(dates[j - 2], () => row[j]);
        }
        values.putIfAbsent(row[0], () => tmpValues);
      }
    }
  }

  checkDataStructureIsCorrect(List header) {
    if ((header[0] != 'id') && (header[1] != 'name') && (header.length > 3)) {
      throw Exception('Incorrect data format');
    }
  }

  List<DateTime> getValueDates(List row) {
    List<DateTime> output = [];
    for (int i = 2; i < row.length; i++) {
      output.add(DateTime.parse(row[i]));
    }
    return output;
  }
}
