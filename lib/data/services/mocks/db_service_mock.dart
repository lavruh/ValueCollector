import 'package:rh_collector/data/services/db_service.dart';

class DbServiceMock implements DbService {
  String currentTable = "main";
  @override
  bool isLoaded = false;
  DbServiceMock({
    String? tableName,
  }) : currentTable = tableName ?? "main";
  Map db = {"main": {}};

  @override
  addEntry(Map<String, dynamic> entry, {String? keyField, String? table}) {
    String t = _setTable(table);
    db[t].putIfAbsent(entry[keyField ?? "id"].toString(), () => entry);
  }

  @override
  Future<List<Map<String, dynamic>>> getEntries(List<List> request,
      {String? table}) async {
    String t = _setTable(table);
    List<Map<String, dynamic>> result = [];
    if (request.isNotEmpty) {
      for (List r in request) {
        if (r.isNotEmpty) {
          db[t].forEach((key, value) {
            if (r[1] == "" && value[r[0]] != "") {
              result.add(value);
            } else if (value[r[0]].contains(r[1])) {
              result.add(value);
            }
          });
        }
      }
    } else {
      if (db.containsKey(t)) {
        db[t].forEach((key, value) {
          result.add(value);
        });
      }
    }
    return result;
  }

  @override
  removeEntry(String id, {String? table}) {
    String t = _setTable(table);
    final map = db[t];
    map.remove(id);
  }

  @override
  updateEntry(Map<String, dynamic> entry, {String? keyField, String? table}) {
    String f = keyField ?? "id";
    String key = entry[f].toString();
    String t = _setTable(table);

    if (db[t].containsKey(key)) {
      db[t].update(key, (value) => entry);
    } else {
      db[t].putIfAbsent(key, () => entry);
    }
  }

  DbServiceMock.testData(
      {required List<Map<String, dynamic>> values, String? tableName}) {
    if (tableName != null) {
      selectTable(tableName);
    }
    addEntries(values: values);
  }

  addEntries(
      {required List<Map<String, dynamic>> values,
      String? keyField,
      String? table}) {
    for (var element in values) {
      addEntry(element, keyField: keyField, table: table);
    }
  }

  selectTable(String tableName) {
    currentTable = tableName;
    db.putIfAbsent(currentTable, () => {});
  }

  @override
  clearDb({required String table}) {
    db.clear();
  }

  @override
  openDb() {}

  String _setTable(String? table) {
    final t = table ?? currentTable;
    db.putIfAbsent(t, () => {});
    return t;
  }
}
