import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/mocks/db_service_mock.dart';
import 'package:test/test.dart';

main() {
  DbService db = DbServiceMock();

  Map<String, dynamic> entry = {"data": "data", "value": 0, "id": "1"};

  tearDown(() {
    db = DbServiceMock();
  });

  test("select table", () {
    String inp = "some name";
    expect(db.currentTable, equals("main"));
    db.selectTable(inp);
    expect(db.currentTable, equals(inp));
  });

  test('add and get entry', () {
    db.addEntry(entry);

    List<Map<String, dynamic>> res = db.getEntries([
      ["data", ""]
    ]);
    expect(res, contains(entry));
  });

  test("update entry", () {
    db.addEntry(entry);
    db.addEntry({"data": "d1", "id": "2"});
    List<Map<String, dynamic>> res = db.getEntries([
      ["data", ""]
    ]);
    var e = res.first;
    e["data"] = "new data";
    db.updateEntry(e);
    res = db.getEntries([
      ["data", ""]
    ]);
    expect(res.length, 2);
    expect(res.first["data"], equals("new data"));
  });

  test("remove entry", () {
    db.addEntry(entry);
    db.addEntry({"data": "d1", "id": "2"});
    List<Map<String, dynamic>> res = db.getEntries([
      ["data", ""]
    ]);
    expect(res.length, 2);
    db.removeEntry("2");
    res = db.getEntries([
      ["data", ""]
    ]);
    expect(res.length, 1);
  });

  test('get by id', () {
    db.addEntry(entry);
    db.addEntry({"data": "d1", "id": "66"});
    db.addEntry({"data": "d1", "id": "3"});
    List<Map<String, dynamic>> res = db.getEntries([
      ["id", "66"]
    ]);
    expect(res.length, 1);
    expect(res.first["id"], "66");
  });
}
