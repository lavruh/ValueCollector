import 'package:get/get.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/domain/entities/meter.dart';

class MetersState extends GetxController {
  final meters = <Meter>[].obs;
  final db = Get.find<DbService>(tag: "meters");

  getMeters(String groupId) {
    meters.value = db
        .getEntries([
          ["groupId", groupId]
        ])
        .map((e) => Meter.fromJson(e))
        .toList();
  }

  updateMeter(Meter m) {
    // db.addEntry(m.toJson());
    db.updateEntry(m.toJson());
  }
}
