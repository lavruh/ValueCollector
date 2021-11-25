import 'package:flutter/material.dart';
import 'package:rh_collector/data/services/db_service.dart';

class DbServiceMock implements DbService {
  String currentTable = "main";
  Map db = {"main": {}};
  @override
  addEntry(Map<String, dynamic> entry, {String? keyField}) {
    db[currentTable].putIfAbsent(entry[keyField ?? "id"], () => entry);
  }

  @override
  List<Map<String, dynamic>> getEntries(List<List> request) {
    List<Map<String, dynamic>> result = [];
    if (request.isNotEmpty) {
      for (List r in request) {
        if (r.isNotEmpty) {
          db[currentTable].forEach((key, value) {
            if (r[1] == "" && value[r[0]] != "") {
              result.add(value);
            } else if (value[r[0]].contains(r[1])) {
              result.add(value);
            }
          });
        }
      }
    }
    return result;
  }

  @override
  removeEntry(String id) {
    db[currentTable].remove(id);
  }

  @override
  updateEntry(Map<String, dynamic> entry, {String? keyField, String? table}) {
    String f = keyField ?? "id";
    if (db[currentTable].containsKey(entry[f])) {
      db[currentTable].update(entry[f], (value) => entry);
    } else {
      db[currentTable].putIfAbsent(entry[f], () => entry);
    }
  }

  DbServiceMock.testMeters() {
    final values = [
      {
        "id": UniqueKey().toString(),
        "name": "m1",
        "groupId": "",
      },
      {
        "id": UniqueKey().toString(),
        "name": "name",
        "unit": "unit",
        "groupId": "W",
      },
      {
        "id": UniqueKey().toString(),
        "name": "m2",
        "groupId": "W",
      }
    ];

    for (var element in values) {
      addEntry(element);
    }
  }

  DbServiceMock.testMeterValues() {
    final values = [
      {
        "date": DateTime.now().millisecondsSinceEpoch,
        "value": 1,
        "correction": 1,
      },
      {
        "date": DateTime.now().millisecondsSinceEpoch + 1,
        "value": 2,
        "correction": 0,
      },
      {
        "date": DateTime.now().millisecondsSinceEpoch + 2,
        "value": 3,
        "correction": 1,
      },
    ];

    for (var element in values) {
      addEntry(element, keyField: "date");
    }
  }

  @override
  selectTable(String tableName) {
    currentTable = tableName;
    db.putIfAbsent(currentTable, () => {});
  }
}
