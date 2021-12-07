import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter_group.dart';

class MeterGroups extends GetxController {
  Map<String, MeterGroup> _groups = {
    "W": MeterGroup(name: "Weekly", id: "W"),
    "M": MeterGroup(name: "Monthly", id: "M"),
  }.obs;

  final selected = <String>[].obs();

  MeterGroups() {
    _preventSelectedEmpty();
  }

  Map<String, MeterGroup> get groups => _groups;

  set groups(Map<String, MeterGroup> groups) {
    _groups = groups;
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
    update();
  }

  String getName(String id) {
    return _groups[id]?.name ?? "";
  }

  addGroup(MeterGroup g) {
    _groups.putIfAbsent(g.id, () => g);
  }

  MeterGroup? getGroup(String id) {
    if (_groups.containsKey(id)) {
      return _groups[id];
    }
  }

  void _preventSelectedEmpty() {
    if (selected.isEmpty) {
      selected.add(_groups.values.first.id);
    }
  }
}
