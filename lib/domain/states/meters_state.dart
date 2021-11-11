import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_group.dart';

class MetersState extends GetxController {
  final meters = <Meter>[].obs;

  getMeters(MeterGroup group) {}

  updateMeter(Meter m) {}
}
