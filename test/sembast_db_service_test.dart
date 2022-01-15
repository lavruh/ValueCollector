import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/sembast_db_service.dart';
import 'package:rh_collector/di.dart';
import 'package:test/test.dart';

main() {
  appDataPath = "/home/lavruh/AndroidStudioProjects/RhCollector/test/db_tests";
  DbService db = SembastDbService(dbName: "tests");

  Map<String, dynamic> entry = {"data": "data", "value": 0, "id": "1"};

  tearDown(() async {
    await db.clearDb();
  });

  test("select table", () {
    String inp = "some name";
    expect(db.currentTable, equals("main"));
    db.selectTable(inp);
    expect(db.currentTable, equals(inp));
  });

  test('add and get entry', () async {
    await db.addEntry(entry);

    List<Map<String, dynamic>> res = await db.getEntries([]);
    expect(res.any((element) => element["value"] == entry["value"]), true);
    expect(res.any((element) => element["data"] == entry["data"]), true);
  });

  test("update entry", () async {
    db.addEntry(entry);
    db.addEntry({"data": "d1", "id": "2"});
    List<Map<String, dynamic>> res = await db.getEntries([
      ["data", ""]
    ]);
    var e = res.first;
    e["data"] = "new data";
    db.updateEntry(e);
    res = await db.getEntries([
      ["data", ""]
    ]);
    expect(res.length, 2);
    expect(res.first["data"], equals("new data"));
  });

  test("remove entry", () async {
    db.addEntry(entry);
    db.addEntry({"data": "d1", "id": "2"});
    List<Map<String, dynamic>> res = await db.getEntries([
      ["data", ""]
    ]);
    expect(res.length, 2);
    db.removeEntry("2");
    res = await db.getEntries([
      ["data", ""]
    ]);
    expect(res.length, 1);
  });

  test('get by id', () async {
    db.addEntry(entry);
    db.addEntry({"data": "d1", "id": "66"});
    db.addEntry({"data": "d1", "id": "3"});
    List<Map<String, dynamic>> res = await db.getEntries([
      ["id", "66"]
    ]);
    expect(res.length, 1);
    expect(res.first["id"], "66");
  });
}
