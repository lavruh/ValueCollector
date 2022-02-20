import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/sembast_db_service.dart';
import 'package:rh_collector/di.dart';
import 'package:test/test.dart';

main() {
  appDataPath = "/home/lavruh/AndroidStudioProjects/RhCollector/test/db_tests";
  DbService db = SembastDbService(dbName: "tests");

  Map<String, dynamic> entry = {"data": "data", "value": 0, "id": "1"};

  tearDown(() async {
    await db.clearDb(table: "main");
  });

  test('add and get entry', () async {
    String table = "main";
    await db.addEntry(entry, table: table);

    List<Map<String, dynamic>> res = await db.getEntries([], table: table);
    expect(res.length, 1);
    expect(res.any((element) => element["value"] == entry["value"]), true);
    expect(res.any((element) => element["data"] == entry["data"]), true);
  });

  test("update entry", () async {
    String table = "main";
    await db.addEntry(entry, table: table);
    await db.addEntry({"data": "d1", "id": "2"}, table: table);
    List<Map<String, dynamic>> res = await db.getEntries([], table: table);
    expect(res, isNotEmpty);
    var e = res.first;
    e["data"] = "new data";
    await db.updateEntry(e, table: table);
    res = await db.getEntries([], table: table);
    expect(res.length, 2);
    expect(res.first["data"], equals("new data"));
  });

  test("remove entry", () async {
    String table = "main";
    await db.addEntry(entry, table: table);
    await db.addEntry({"data": "d1", "id": "2"}, table: table);
    List<Map<String, dynamic>> res = await db.getEntries([], table: table);
    expect(res.length, 2);
    await db.removeEntry("2", table: table);
    res = await db.getEntries([], table: table);
    expect(res.length, 1);
  });

  test('get by id', () async {
    String table = "main";
    await db.addEntry(entry, table: table);
    await db.addEntry({"data": "d1", "id": "66"}, table: table);
    await db.addEntry({"data": "d1", "id": "3"}, table: table);
    List<Map<String, dynamic>> res = await db.getEntries([
      ["id", "66"]
    ], table: table);
    expect(res.length, 1);
    expect(res.first["id"], "66");
  });
}
