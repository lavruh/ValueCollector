import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';

class Meter extends GetxController {
  final String id;
  String name;
  String? unit;
  String groupId;
  final values = <MeterValue>[].obs;

  Meter({
    required this.id,
    required this.name,
    required this.groupId,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "unit": unit,
      "groupId": groupId,
    };
  }

  Meter.fromJson(Map<String, dynamic> map)
      : name = map['name'] ?? "",
        id = map['id'] ?? UniqueKey().toString(),
        unit = map['unit'],
        groupId = "groupId";

  getValues() {}

  addValue() {}
}
