import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';

class Meter extends GetxController {
  final String _id;
  String name;
  String? unit;
  String groupId;
  final values = <MeterValue>[].obs;

  Meter({
    String? id,
    required this.name,
    required this.groupId,
  }) : _id = id ?? UniqueKey().toString();

  String get id => _id;

  Map<String, dynamic> toJson() {
    return {
      "id": _id,
      "name": name,
      "unit": unit,
      "groupId": groupId,
    };
  }

  Meter.fromJson(Map<String, dynamic> map)
      : name = map['name'] ?? "",
        _id = map['id'] ?? UniqueKey().toString(),
        unit = map['unit'],
        groupId = map["groupId"];

  getValues() {}

  addValue() {}
}
