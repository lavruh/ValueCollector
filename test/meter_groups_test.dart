import 'package:get/get.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/mocks/db_service_mock.dart';
import 'package:rh_collector/domain/entities/meter_group.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  final db = Get.put<DbService>(DbServiceMock());
  MeterGroups state = MeterGroups();

  tearDown(() async {
    await (db as DbServiceMock).clearDb(table: "groups");
    state = MeterGroups();
  });

  test('load groups from db', () async {
    (db as DbServiceMock).addEntries(values: [
      MeterGroup(name: "W", id: "W").toJson(),
      MeterGroup(name: "Mee", id: "M").toJson(),
      MeterGroup(name: "some").toJson(),
    ], table: "groups");

    await state.getGroups();

    expect(state.groups.length, 3);
    expect(state.groups.keys, contains("W"));
  });

  test('save group to db', () async {
    MeterGroup testGroup = MeterGroup(name: "test_group");
    state.addGroup(testGroup);
    expect(state.groups.keys, contains(testGroup.id));
    expect((db as DbServiceMock).db.keys, contains("groups"));
    final res = await db.getEntries([], table: "groups");
    expect(res, anyElement((e) {
      return e["id"] == testGroup.id;
    }));
  });

  test('delete group', () async {
    MeterGroup testGroup = MeterGroup(name: "test_group");
    (db as DbServiceMock).addEntries(values: [
      MeterGroup(name: "W", id: "W").toJson(),
      MeterGroup(name: "Mee", id: "M").toJson(),
    ], table: "groups");
    await state.addGroup(testGroup);
    expect(state.groups.length, 3);
    state.deleteGroup(testGroup.id);
    expect(state.groups.length, 2);
    expect(state.selected.any((e) => e == testGroup.id), false);
    final res = await db.getEntries([], table: "groups");
    expect(res.length, 2);
  });

  test('Update group', () async {
    (db as DbServiceMock).addEntries(values: [
      MeterGroup(name: "W", id: "W").toJson(),
      MeterGroup(name: "Mee", id: "M").toJson(),
      MeterGroup(name: "some").toJson(),
    ], table: "groups");
    await state.getGroups();
    MeterGroup g = state.groups.values.last;
    expect(g.name, "some");
    g.name = "new_name";
    await state.addGroup(g);
    expect(state.groups.values.last.name, g.name);
    expect(db.db["groups"].values.last["name"], g.name);
  });
}
