import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';

class MetersRepo {
  List<Meter> meters = [];
  late DbService db;

  getMeters() {}

  safeMeters() {}

  List<MeterValue> getMeterValues({
    required String meterId,
    required List<List> request,
  }) {
    return [];
  }

  saveMeterValue(MeterValue value) {}
}
