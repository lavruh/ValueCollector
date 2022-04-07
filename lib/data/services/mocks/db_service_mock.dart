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
    String _table = _setTable(table);
    db[_table].putIfAbsent(entry[keyField ?? "id"].toString(), () => entry);
  }

  @override
  Future<List<Map<String, dynamic>>> getEntries(List<List> request,
      {String? table}) async {
    String _table = _setTable(table);
    List<Map<String, dynamic>> result = [];
    if (request.isNotEmpty) {
      for (List r in request) {
        if (r.isNotEmpty) {
          db[_table].forEach((key, value) {
            if (r[1] == "" && value[r[0]] != "") {
              result.add(value);
            } else if (value[r[0]].contains(r[1])) {
              result.add(value);
            }
          });
        }
      }
    } else {
      if (db.containsKey(_table)) {
        db[_table].forEach((key, value) {
          result.add(value);
        });
      }
    }
    return result;
  }

  @override
  removeEntry(String id, {String? table}) {
    String _table = _setTable(table);
    Map t = db[_table];
    t.remove(id);
  }

  @override
  updateEntry(Map<String, dynamic> entry, {String? keyField, String? table}) {
    String f = keyField ?? "id";
    String key = entry[f].toString();
    String _table = _setTable(table);

    if (db[_table].containsKey(key)) {
      db[_table].update(key, (value) => entry);
    } else {
      db[_table].putIfAbsent(key, () => entry);
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
    String _table = table ?? currentTable;
    db.putIfAbsent(_table, () => {});
    return _table;
  }
}
