import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rh_collector/domain/entities/meter_rate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rh_collector/domain/states/values_calculations_state.dart';
import 'package:rh_collector/ui/widgets/rates_editor/limit_edit_dialog.dart';
import 'package:rh_collector/ui/widgets/value_select_widget.dart';

class MeterRateWidget extends StatelessWidget {
  const MeterRateWidget(
      {Key? key, required this.meterRate, required this.updateCallback})
      : super(key: key);
  final MeterRate meterRate;
  final Function(MeterRate meter) updateCallback;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ValueSelectWidget(
                  items: const ["rh", "coldwater", "hotwater", "gas", "elec"],
                  callback: _changeMeterType,
                  initValue: meterRate.meterType.index),
              ActionChip(
                  label: Text(DateFormat("y-MM-dd")
                          .format(meterRate.timeRange.start) +
                      " - " +
                      DateFormat("y-MM-dd").format(meterRate.timeRange.end)),
                  onPressed: _changeDateRange),
            ],
          ),
          Text(AppLocalizations.of(context)!.limit +
              " - " +
              AppLocalizations.of(context)!.price),
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

  _changeMeterType(int val) {
    updateCallback(meterRate.copyWith(meterType: MeterType.values[val]));
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
