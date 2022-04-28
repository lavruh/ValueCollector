import 'package:get/get.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/domain/entities/meter_group.dart';
import 'package:rh_collector/domain/states/meters_state.dart';

class MeterGroups extends GetxController {
  final groups = <String, MeterGroup>{
    "W": MeterGroup(name: "Weekly", id: "W"),
    "M": MeterGroup(name: "Monthly", id: "M"),
  }.obs;
  final db = Get.find<DbService>();
  final selected = <String>[].obs;
  final String table = "groups";
  final editMode = false.obs;

  MeterGroups() {
    _preventSelectedEmpty();
    getGroups();
  }

  bool isSelected(MeterGroup g) {
    return selected.contains(g.id);
  }

  toggleGroupSelect(MeterGroup g) {
    final idx = selected.indexOf(g.id);
    if (idx == -1) {
      selected.add(g.id);
    } else {
      selected.removeAt(idx);
      _preventSelectedEmpty();
    }
    updateMetersState();
    update();
  }

  updateMetersState() {
    final metersState = Get.find<MetersState>();
    metersState.getMeters(selected);
    metersState.update();
  }

  String getName(String id) {
    return groups[id]?.name ?? "";
  }

  addGroup(MeterGroup g) {
    groups.putIfAbsent(g.id, () => g);
    db.updateEntry(g.toJson(), table: table);
    update();
  }

  updateGroup(MeterGroup g) {
    if (groups.keys.contains(g.id)) {
      groups[g.id] = g;
      db.updateEntry(g.toJson(), table: table);
    }
  }

  MeterGroup? getGroup(String id) {
    if (groups.containsKey(id)) {
      return groups[id];
    }
    return null;
  }

  void _preventSelectedEmpty() {
    if (selected.isEmpty) {
      selected.add(groups.values.first.id);
    }
  }

  getGroups() async {
    groups.clear();
    List<Map<String, dynamic>> r = await db.getEntries([], table: table);
    for (Map<String, dynamic> map in r) {
      MeterGroup g = MeterGroup.fromJson(map);
      groups.putIfAbsent(g.id, () => g);
    }
// Put standart groups
    groups.putIfAbsent("W", () => MeterGroup(name: "Weekly", id: "W"));
    groups.putIfAbsent("M", () => MeterGroup(name: "Monthly", id: "M"));
  }

  void deleteGroup(String id) async {
    groups.remove(id);
    selected.removeWhere((element) => element == id);
    await db.removeEntry(id, table: table);
    _preventSelectedEmpty();
  }

  toggleMode() {
    editMode.value = !editMode.value;
  }

  String getFirstSelectedGroupId() {
    if (selected.isNotEmpty) {
      return selected.first;
    } else {
      throw Exception("No meter group selected");
    }
  }
}
