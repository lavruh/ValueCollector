import 'package:flutter/material.dart';
import 'package:rh_collector/data/services/db_service.dart';

class DbServiceMock implements DbService {
  Map db = {};
  @override
  addEntry(Map<String, dynamic> entry) {
    db.putIfAbsent(entry["id"], () => entry);
  }

  @override
  List<Map<String, dynamic>> getEntries(List<List> request) {
    List<Map<String, dynamic>> result = [];
    if (request.isNotEmpty) {
      for (List r in request) {
        if (r.isNotEmpty) {
          db.forEach((key, value) {
            if (value[r[0]].contains(r[1])) {
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
    db.remove(id);
  }

  @override
  updateEntry(Map<String, dynamic> entry) {
    if (db.containsKey(entry["id"])) {
      db.update(entry["id"], (value) => entry);
    } else {
      db.putIfAbsent(entry["id"], () => entry);
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
}
