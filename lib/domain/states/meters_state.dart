import 'package:get/get.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/domain/entities/meter.dart';

class MetersState extends GetxController {
  final meters = <Meter>[].obs;
  final db = Get.find<DbService>();

  getMeters(String groupId) {
    db.selectTable("meters");
    meters.value = db
        .getEntries([
          ["groupId", groupId]
        ])
        .map((e) => Meter.fromJson(e))
        .toList();
  }

  updateMeter(Meter m) {
    db.selectTable("meters");
    db.updateEntry(m.toJson());
  }
}
