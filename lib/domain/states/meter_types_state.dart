import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/data/dtos/meter_type_dto.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/info_msg_service.dart';

import 'package:rh_collector/domain/entities/meter_type.dart';

class MeterTypesState extends GetxController {
  final meterTypes = <String, MeterType>{}.obs;
  final icons = [
    Icons.alarm,
    Icons.water,
    Icons.water_drop,
    Icons.gas_meter,
    Icons.electric_meter,
    Icons.bolt,
    Icons.schedule,
    Icons.solar_power,
    Icons.directions_car,
    Icons.heat_pump
  ];
  final table = "MeterTypes";
  final _db = Get.find<DbService>();
  final _msg = Get.find<InfoMsgService>();

  @override
  void onInit() async {
    await getMeterTypes();
    if (meterTypes.isEmpty) {
      await addMeterType(MeterType(name: "Running hours", id: "rh"));
    }
    super.onInit();
  }

  bool isExists(String id) {
    return meterTypes.containsKey(id);
  }

  IconData getIcon(int code) {
    for (IconData d in icons) {
      if (code == d.codePoint) {
        return d;
      }
    }
    throw MeterTypeException("No valid Icon");
  }

  MeterType getMeterTypeById(String id) {
    if (isExists(id)) {
      return meterTypes[id]!;
    } else {
      throw MeterTypeException("Meter type with id - $id does not exists");
    }
  }

  List<MeterType> getMeterTypesList() {
    return meterTypes.values.toList();
  }

  getMeterTypes() async {
    final request = await _db.getEntries([], table: table);
    for (Map<String, dynamic> map in request) {
      final type = MeterTypeDto.fromMap(map).toDomain();
      meterTypes.putIfAbsent(type.id, () => type);
    }
  }

  addMeterType(MeterType meterType) async {
    meterTypes.putIfAbsent(meterType.id, () => meterType);
    _db.updateEntry(MeterTypeDto.fromDomain(meterType).toMap(), table: table);
  }

  removeMeterType(String id) async {
    if (isExists(id)) {
      meterTypes.remove(id);
      _db.removeEntry(id, table: table);
    }
  }

  updateMeterType(MeterType updatedType) async {
    final id = updatedType.id;
    if (isExists(id)) {
      meterTypes[id] = updatedType;
      _db.updateEntry(MeterTypeDto.fromDomain(updatedType).toMap(),
          table: table);
    } else {
      _msg.push(msg: "Meter type does not exist");
    }
  }
}

class MeterTypeException implements Exception {
  String msg;
  MeterTypeException(this.msg);
  @override
  String toString() => 'MeterTypeException($msg)';
}
