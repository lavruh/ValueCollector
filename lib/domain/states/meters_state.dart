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

  getMeters(List<String> groupId) async {
    meters.clear();
    List<List> request = [];
    for (String id in groupId) {
      request.add(["groupId", id]);
    }
    List res = await db.getEntries(request, table: "meters");

    for (Map<String, dynamic> e in res) {
      Meter m = Meter.fromJson(e);
      final tmp = Get.put<Meter>(m, tag: m.id);
      meters.value.add(m);
    }

    update();
  }

  updateMeter(Meter m) async {
    await m.updateDb();
    update();
  }

  addNewMeter(Meter? m) {
    if (m != null) {
      meters.add(m);
      Get.put<Meter>(m, tag: m.id);
      updateMeter(m);
    } else {
      updateMeter(Meter(
        name: "name",
        groupId: Get.find<MeterGroups>().selected.first,
      ));
    }
  }
}
