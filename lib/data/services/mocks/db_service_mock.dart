import 'package:flutter/material.dart';

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
    db[currentTable]
        .putIfAbsent(entry[keyField ?? "id"].toString(), () => entry);
  }

  @override
  Future<List<Map<String, dynamic>>> getEntries(List<List> request,
      {String? table}) async {
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
  removeEntry(String id, {String? table}) {
    Map table = db[currentTable];
    table.remove(id);
  }

  @override
  updateEntry(Map<String, dynamic> entry, {String? keyField, String? table}) {
    String f = keyField ?? "id";
    String key = entry[f].toString();
    if (db[currentTable].containsKey(key)) {
      db[currentTable].update(key, (value) => entry);
    } else {
      db[currentTable].putIfAbsent(key, () => entry);
    }
  }

  DbServiceMock.testData(
      {required List<Map<String, dynamic>> values, String? tableName}) {
    if (tableName != null) {
      selectTable(tableName);
    }
    addEntries(values: values);
  }

  addEntries({required List<Map<String, dynamic>> values, String? keyField}) {
    for (var element in values) {
      addEntry(element, keyField: keyField);
    }
  }

  @override
  selectTable(String tableName) {
    currentTable = tableName;
    db.putIfAbsent(currentTable, () => {});
  }

  @override
  clearDb({required String table}) {
    db["main"].clear();
  }

  @override
  openDb() {
    // TODO: implement openDb
    throw UnimplementedError();
  }
}
