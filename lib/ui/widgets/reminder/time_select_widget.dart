import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/reminder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeSelectWidget extends StatelessWidget {
  TimeSelectWidget({Key? key, required this.updateTime, required this.schedule})
      : super(key: key);
  final _now = DateTime.now();
  final ValidSchedule schedule;
  final void Function(TimeOfDay time) updateTime;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
        onPressed: () async {
          final time = await Get.dialog<TimeOfDay>(TimePickerDialog(
            initialTime: TimeOfDay(
                hour: schedule.hour ?? _now.hour,
                minute: schedule.minute ?? _now.minute),
          ));
          if (time != null) {
            updateTime(time);
          }
        },
        side: const BorderSide(width: 0),
        label: Text(schedule.time != null
            ? schedule.time!.format(context)
            : AppLocalizations.of(context)!.hourMinnute));
  }
}
