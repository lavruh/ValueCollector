import 'package:get/get.dart';
import 'package:rh_collector/data/dtos/meter_dto.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/info_msg_service.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/states/meter_editor_state.dart';

import 'meter_groups_state.dart';

class MetersState extends GetxController {
  final meters = <Meter>[].obs;
  final db = Get.find<DbService>();
  final msg = Get.find<InfoMsgService>();
  final meterGroups = Get.find<MeterGroups>();
  final editor = Get.find<MeterEditorState>();

  Meter getMeter(String id) {
    int idx = meters.indexWhere((element) => element.id == id);
    if (idx != -1) {
      return meters[idx];
    }
    throw Exception("No meters with id $id found");
  }

  getMeters(List<String> groupId) async {
    meters.clear();
    List res = await db.getEntries(_createRequest(groupId), table: "meters");
    for (final e in res) {
      Meter m = MeterDto.fromMap(e).toDomain();
      editor.set(m);
      await editor.getValues();
      final meter = editor.get();
      meters.add(meter);
    }
    update();
  }

  updateMeter(Meter m) async {
    int index = meters.indexWhere((element) => element.id == m.id);
    if (index == -1) {
      msg.push(msg: "Meter with ${m.id} does not exists");
      return;
    }
    meters[index] = m;
    await db.updateEntry(MeterDto.fromDomain(m).toMap(), table: "meters");
    update();
  }

  addNewMeter(Meter? meter) {
    Meter m = meter ??
        Meter(
          name: "new_meter",
          groupId: meterGroups.getFirstSelectedGroupId(),
        );
    meters.add(m);
    updateMeter(m);
  }

  deleteMeter(String id) async {
    int index = meters.indexWhere((element) => element.id == id);
    if (index > -1) {
      db.removeEntry(id, table: "meters");
      db.clearDb(table: id);
      meters.removeAt(index);
    }
    update();
  }

  filterMetersByName({
    required String filter,
    required List<String> groupId,
  }) async {
    meters.clear();
    List<List> req = _createRequest(groupId);
    List res = await db.getEntries(req, table: "meters");
    for (final e in res) {
      Meter m = MeterDto.fromMap(e).toDomain();
      if (m.name.contains(RegExp(filter, caseSensitive: false))) {
        editor.set(m);
        await editor.getValues();
        meters.add(editor.get());
      }
    }
    update();
  }

  List<List> _createRequest(List<String> groupId) {
    List<List> request = [];
    for (String id in groupId) {
      request.add(["groupId", id]);
    }
    return request;
  }
}
