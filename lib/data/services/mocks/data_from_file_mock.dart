import 'package:intl/intl.dart';
import 'package:rh_collector/data/services/data_from_service.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';

class DataFromFileMock implements DataFromFileService {
  Map data = {};

  @override
  exportData() {
    // TODO: implement exportData
    throw UnimplementedError();
  }

  @override
  List<Map> getMeterValues(String meterId) {
    List<Map> output = [];
    if (data.isNotEmpty) {
      output.add(data[meterId]);
    }
    return output;
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
  List getMeters() => data.values.toList();

  @override
  openFile(String filePath) {}

  @override
  setMeterReading({
    required String meterId,
    required String val,
  }) {
    if (data.containsKey(meterId)) {
      data[meterId]["newValue"] = val;
    } else {
      throw Exception("File does not contain meter id[$meterId]");
    }
  }
}
