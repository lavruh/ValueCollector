import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rh_collector/domain/entities/meter_rate.dart';
import 'package:rh_collector/l10n/app_localizations.dart';
import 'package:rh_collector/ui/widgets/meter_type_select_widget.dart';
import 'package:rh_collector/ui/widgets/rates_editor/limit_edit_dialog.dart';

class MeterRateWidget extends StatelessWidget {
  const MeterRateWidget(
      {super.key, required this.meterRate, required this.updateCallback});
  final MeterRate meterRate;
  final Function(MeterRate meter) updateCallback;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    if (local == null) return Center(child: CircularProgressIndicator());
    return Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MeterTypeSelectWidget(
                  initValueId: meterRate.meterType, callback: _changeMeterType),
              ActionChip(
                  label: Text(
                      "${DateFormat("y-MM-dd").format(meterRate.timeRange.start)} - ${DateFormat("y-MM-dd").format(meterRate.timeRange.end)}"),
                  onPressed: _changeDateRange),
            ],
          ),
          Text("${local.limit} - ${local.price}"),
          SingleChildScrollView(
            child: Wrap(
              children: _genLimitsWidgets(),
            ),
          ),
        ],
      ),
    );
  }

  void _changeDateRange() async {
    final range = await Get.dialog<DateTimeRange>(DateRangePickerDialog(
        initialDateRange: meterRate.timeRange,
        currentDate: DateTime.now(),
        firstDate: DateTime(2010),
        lastDate: DateTime(2030)));
    if (range != null) {
      updateCallback(meterRate.copyWith(timeRange: range));
    }
  }

  _changeMeterType(String val) {
    updateCallback(meterRate.copyWith(meterType: val));
  }

  _changeRateLimits(Map<int, double> val) {
    updateCallback(meterRate.copyWith(rateLimits: val));
  }

  List<Widget> _genLimitsWidgets() {
    List<Widget> rateLimits = [];
    for (int limit in meterRate.rateLimits.keys) {
      final price = meterRate.rateLimits[limit];
      rateLimits.add(
        InkWell(
          child: ActionChip(
            label: Text("$limit - $price"),
            onPressed: () async {
              final result = await Get.dialog<Map<int, double>?>(
                  LimitEditDialog(limit: limit, price: price!));
              if (result != null) {
                meterRate.rateLimits.remove(limit);
                meterRate.rateLimits
                    .putIfAbsent(result.keys.first, () => result.values.first);
                _changeRateLimits(meterRate.rateLimits);
              }
            },
          ),
          onLongPress: () {
            meterRate.rateLimits.remove(limit);
            _changeRateLimits(meterRate.rateLimits);
          },
        ),
      );
    }
    rateLimits.add(ActionChip(
        label: const Icon(Icons.add),
        onPressed: () {
          meterRate.rateLimits.putIfAbsent(1, () => 1);
          _changeRateLimits(meterRate.rateLimits);
        }));
    return rateLimits;
  }
}
