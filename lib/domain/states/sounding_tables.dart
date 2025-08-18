import 'package:rh_collector/data/services/i_sounding_table_data.dart';

class SoundingTables {
  Map<String, Map<num, num>> tables = {};
  final ISoundingTableData service;

  SoundingTables(this.service);

  num calculateVolume(String table, num level) {
    try {
      final t = _getTable(table);
      for (var i = 0; i < t.length; i++) {
        if (t.keys.elementAt(i) == level) {
          return t.values.elementAt(i);
        }
        if (t.keys.elementAt(i) > level) {
          if (i == 0) {
            return t.values.first;
          }
          final lowerLevel = t.keys.elementAt(i - 1);
          final upperLevel = t.keys.elementAt(i);
          final lowerValue = t.values.elementAt(i - 1);
          final upperValue = t.values.elementAt(i);
          final interpolatedValue = lowerValue +
              ((upperValue - lowerValue) / (upperLevel - lowerLevel)) *
                  (level - lowerLevel);
          return interpolatedValue;
        }
      }
      final upperValue = t.values.last;
      return upperValue;
    } catch (e) {
      rethrow;
    }
  }

  Map<num, num> _getTable(String table) {
    if (tables.containsKey(table)) {
      final t = tables[table];
      if (t == null) {
        tables.remove(table);
        loadTable(table);
        throw Exception("Table is null");
      }
      return t;
    }
    loadTable(table);
    throw Exception("Table is not loaded");
  }

  Future<void> loadTable(String table) async {
    try {
      final t = await service.loadSoundingTable(table);
      tables[table] = t;
    } catch (e) {
      rethrow;
    }
  }
}
