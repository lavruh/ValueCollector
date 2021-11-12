import 'package:rh_collector/domain/entities/meter_group.dart';

class MeterGroups {
  Map<String, MeterGroup> _groups = {
    "W": MeterGroup(name: "Weekly", id: "W"),
    "M": MeterGroup(name: "Monthly", id: "M"),
  };

  Map<String, MeterGroup> get groups => _groups;

  set groups(Map<String, MeterGroup> groups) {
    _groups = groups;
  }

  addGroup(MeterGroup g) {
    _groups.putIfAbsent(g.id, () => g);
  }

  MeterGroup? getGroup(String id) {
    if (_groups.containsKey(id)) {
      return _groups[id];
    }
  }
}
