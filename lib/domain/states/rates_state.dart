import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rh_collector/data/dtos/meter_rate_dto.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/data/services/info_msg_service.dart';
import 'package:rh_collector/domain/entities/meter_rate.dart';
import 'package:rh_collector/domain/entities/meter_type.dart';

class RatesState extends GetxController {
  final rates = <MeterRate>[].obs;
  final db = Get.find<DbService>();
  final _dbTableName = "MeterRates";

  @override
  onInit() {
    loadRates();
    super.onInit();
  }

  List<MeterRate> getRates({
    required DateTimeRange dateRange,
    required MeterType meterType,
  }) {
    return rates.where((rate) {
      if (meterType.id == rate.meterType &&
          max(dateRange.start.millisecondsSinceEpoch,
                  rate.timeRange.start.millisecondsSinceEpoch) <=
              min(dateRange.end.millisecondsSinceEpoch,
                  rate.timeRange.end.millisecondsSinceEpoch)) {
        return true;
      }
      return false;
    }).toList();
  }

  loadRates() async {
    rates.clear();
    final request = await db.getEntries([], table: _dbTableName);
    rates.value =
        request.map((e) => MeterRateDto.fromMap(e).toDomain()).toList();
  }

  addRate({required MeterRate rate}) async {
    rates.add(rate);
    await updateRateInDb(rate);
  }

  removeRate({required MeterRate rate}) {
    rates.remove(rate);
    db.removeEntry(rate.id, table: _dbTableName);
  }

  updateRate({required MeterRate rate, int? index}) async {
    index ??= rates.indexWhere((element) => element.id == rate.id);
    if (index == -1) {
      Get.find<InfoMsgService>().push(msg: "Failed to update rate [$rate]");
      return;
    }
    rates[index] = rate;
    await updateRateInDb(rate);
  }

  updateRateInDb(MeterRate rate) async {
    await db.updateEntry(MeterRateDto.formDomain(rate).toMap(),
        table: _dbTableName);
  }

  MeterRate getLatestRate(
      {required DateTimeRange dateRange, required MeterType meterType}) {
    List<MeterRate> res = getRates(dateRange: dateRange, meterType: meterType);
    if (res.isEmpty) {
      throw MeterRatesException("No rate for time preiod $dateRange");
    }
    res.sort(((a, b) =>
        a.timeRange.end.millisecondsSinceEpoch -
        b.timeRange.end.millisecondsSinceEpoch));
    return res.last;
  }
}

class MeterRatesException implements Exception {
  String msg;
  MeterRatesException(this.msg);

  @override
  String toString() => 'MeterRatesException($msg)';
}
