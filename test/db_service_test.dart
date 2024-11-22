import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/mocks/db_service_mock.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  DbService db = DbServiceMock();

  Map<String, dynamic> entry = {"data": "data", "value": 0, "id": "1"};

  tearDown(() {
    db = DbServiceMock();
  });

  test('add and get entry', () async {
    String table = "main";
    db.addEntry(entry, table: table);

    List<Map<String, dynamic>> res = await db.getEntries([], table: table);
    expect(res, contains(entry));
  });

  test("update entry", () async {
    String table = "main";
    db.addEntry(entry, table: table);
    db.addEntry({"data": "d1", "id": "2"}, table: table);
    List<Map<String, dynamic>> res = await db.getEntries([], table: table);
    var e = res.first;
    e["data"] = "new data";
    db.updateEntry(e, table: table);
    res = await db.getEntries([], table: table);
    expect(res.length, 2);
    expect(res.first["data"], equals("new data"));
  });

  test("remove entry", () async {
    String table = "main";
    db.addEntry(entry, table: table);
    db.addEntry({"data": "d1", "id": "2"}, table: table);
    List<Map<String, dynamic>> res = await db.getEntries([], table: table);
    expect(res.length, 2);
    db.removeEntry("2", table: table);
    res = await db.getEntries([], table: table);
    expect(res.length, 1);
  });

  test('get by id', () async {
    String table = "main";
    db.addEntry(entry, table: table);
    db.addEntry({"data": "d1", "id": "66"}, table: table);
    db.addEntry({"data": "d1", "id": "3"}, table: table);
    List<Map<String, dynamic>> res = await db.getEntries([
      ["id", "66"]
    ], table: table);
    expect(res.length, 1);
    expect(res.first["id"], "66");
  });
}
