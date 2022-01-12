import 'package:get/get.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/domain/entities/meter.dart';

import 'meter_groups_state.dart';

class MetersState extends GetxController {
  final meters = <Meter>[].obs;
  final db = Get.find<DbService>();

  Meter getMeter(String id) {
    int idx = meters.indexWhere((element) => element.id == id);
    if (idx != -1) {
      Meter m = meters[idx];
      return m;
    } else {
      throw Exception("No Meter with id[$id] found");
    }
  }

  getMeters(List<String> groupId) {
    db.selectTable("meters");
    List<List> request = [];
    for (String id in groupId) {
      request.add(["groupId", id]);
    }
    meters.value =
        db.getEntries(request).map((e) => Meter.fromJson(e)).toList();
  }

  updateMeter(Meter m) {
    db.selectTable("meters");
    db.updateEntry(m.toJson());
    update();
  }

  addNewMeter(Meter? m) {
    if (m != null) {
      meters.add(m);
      updateMeter(m);
    } else {
      updateMeter(Meter(
        name: "name",
        groupId: Get.find<MeterGroups>().selected.first,
      ));
    }
  }
}
