import 'dart:async';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:rh_collector/di.dart';
import 'package:sembast/sembast.dart';

import 'package:rh_collector/data/services/db_service.dart';
import 'package:sembast/sembast_io.dart';

class SembastDbService implements DbService {
  String _dbName = "values_db";
  @override
  bool isLoaded = false;
  Database? _db;
  Completer<Database>? _dbOpenCompleter;

  SembastDbService({required String dbName}) {
    if (dbName.isNotEmpty) {
      _dbName = dbName;
      openDb().then((value) => _db = value);
    }
  }

  @override
  Future<Database> openDb() async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      try {
        final String path = join(appDataPath, "$_dbName.db");
        final database = await databaseFactoryIo.openDatabase(path);
        _dbOpenCompleter!.complete(database);
        isLoaded = true;
      } on PlatformException {
        throw ("Failed to open db");
      }
    }
    return _dbOpenCompleter!.future;
  }

  Finder mapRequestToFinder(List<List> request) {
    List<Filter> filters = [];
    if (request.isEmpty) {
      return Finder();
    }
    for (List req in request) {
      if (req.length == 2) {
        filters.add(Filter.equals(req[0], req[1]));
      }
    }
    return Finder(filter: Filter.or(filters));
  }

  @override
  addEntry(Map<String, dynamic> entry, {required String table}) async {
    StoreRef _store = intMapStoreFactory.store(table);
    await _dbOpenCompleter!.future;
    await _db?.transaction((transaction) async {
      await _store.add(transaction, entry);
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getEntries(List<List> request,
      {required String table}) async {
    StoreRef _store = intMapStoreFactory.store(table);
    final Finder finder = mapRequestToFinder(request);
    await _dbOpenCompleter!.future;
    var res = await _store.find(_db!, finder: finder);
    if (res.isNotEmpty) {
      List<Map<String, dynamic>> r = res.map((e) {
        Map<String, dynamic> m = {};
        m.addAll(e.value as Map<String, dynamic>);
        m.addAll({"dbKey": e.key});
        return m;
      }).toList();
      return r;
    }
    return [];
  }

  @override
  removeEntry(String id, {required String table}) async {
    StoreRef _store = intMapStoreFactory.store(table);
    int key = await _getEntryKey(id, table: table);
    await _db?.transaction((transaction) async {
      await _store.record(key).delete(transaction);
    });
  }

  selectTable(String tableName) {}

  @override
  updateEntry(Map<String, dynamic> entry, {required String table}) async {
    StoreRef _store = intMapStoreFactory.store(table);
    int? key = entry["dbKey"];
    if (key == null) {
      String id = entry["id"];
      try {
        key = await _getEntryKey(id, table: table);
      } catch (e) {
        addEntry(entry, table: table);
      }
    }
    if (key != null) {
      await _dbOpenCompleter?.future;
      await _db?.transaction((transaction) async {
        await _store.record(key).update(transaction, entry);
      });
    }
  }

  @override
  clearDb({required String table}) async {
    StoreRef _store = intMapStoreFactory.store(table);
    await _dbOpenCompleter!.future;
    await _store.delete(_db!);
  }

  Future<int> _getEntryKey(String id, {required String table}) async {
    List entries = await getEntries([
      ["id", id]
    ], table: table);
    if (entries.isNotEmpty) {
      return entries.first['dbKey'];
    } else {
      throw ("Entry is not in db");
    }
  }
}
