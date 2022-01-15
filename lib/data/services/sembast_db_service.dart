import 'dart:async';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:rh_collector/di.dart';
import 'package:sembast/sembast.dart';

import 'package:rh_collector/data/services/db_service.dart';
import 'package:sembast/sembast_io.dart';

class SembastDbService implements DbService {
  @override
  String _dbName = "values_db";
  late Database _db;
  Completer<Database>? _dbOpenCompleter;
  late StoreRef _store;
  String get currentTable => _store.name;

  SembastDbService({required String dbName}) {
    if (dbName.isNotEmpty) {
      _dbName = dbName;
      _openDb().then((value) => _db = value);
      _store = intMapStoreFactory.store("main");
    }
  }

  Future<Database> _openDb() async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      try {
        final String path = join(appDataPath, _dbName + ".db");
        final database = await databaseFactoryIo.openDatabase(path);
        _dbOpenCompleter!.complete(database);
      } on PlatformException {
        throw ("Failed to open db");
      }
    }
    return _dbOpenCompleter!.future;
  }

  Finder mapRequestToFinder(List<List> request) {
    List<Filter> filters = [];
    for (List req in request) {
      if (req.length == 2) {
        filters.add(Filter.matches(req[0], req[1]));
      }
    }
    return Finder(filter: Filter.and(filters));
  }

  @override
  addEntry(Map<String, dynamic> entry) async {
    await _dbOpenCompleter!.future;
    await _db.transaction((transaction) async {
      return await _store.add(transaction, entry);
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getEntries(List<List> request) async {
    final Finder finder = mapRequestToFinder(request);
    await _dbOpenCompleter!.future;
    var res = await _store.find(_db, finder: finder);
    if (res.isNotEmpty) {
      List<Map<String, dynamic>> r = res.map((e) {
        Map<String, dynamic> m = {};
        m.addAll(e.value);
        m.addAll({"dbKey": e.key});
        return m;
      }).toList();
      return r;
    }
    return [];
  }

  @override
  removeEntry(String id) {
    // TODO: implement removeEntry
    throw UnimplementedError();
  }

  @override
  selectTable(String tableName) {
    _store = intMapStoreFactory.store(tableName);
  }

  @override
  updateEntry(Map<String, dynamic> entry) {
    // TODO: implement updateEntry
    throw UnimplementedError();
  }

  @override
  set currentTable(String _currentTable) {
    // TODO: implement currentTable
  }

  @override
  clearDb() async {
    await _dbOpenCompleter!.future;
    await _store.delete(_db);
  }
}
