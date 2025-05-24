import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/l10n/app_localizations.dart';
import 'package:rh_collector/ui/widgets/remark_button.dart';

class MeterValueEditWidget extends StatelessWidget {
  const MeterValueEditWidget({
    super.key,
    required this.meterValue,
    this.deleteCallback,
    this.updateCallback,
  });

  final MeterValue meterValue;
  final Function? deleteCallback;
  final Function(MeterValue v)? updateCallback;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    if (local == null) return Center(child: CircularProgressIndicator());
    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          icon: Icons.delete_forever,
          backgroundColor: Colors.red,
          onPressed: (BuildContext context) {
            deleteCallback!(meterValue);
          },
        ),
      ]),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: TextButton(
                  child: Text(
                    DateFormat("yyyy-MM-dd\nHH:mm").format(meterValue.date),
                  ),
                  onPressed: () async {
                    final date = await Get.dialog<DateTime>(DatePickerDialog(
                      initialDate: meterValue.date,
                      firstDate: DateTime(DateTime.now().year - 2),
                      lastDate: DateTime(DateTime.now().year + 2),
                    ));
                    if (date != null) {
                      final initTime = TimeOfDay.fromDateTime(meterValue.date);
                      final time = await Get.dialog<TimeOfDay>(
                          TimePickerDialog(initialTime: initTime));
                      if (time != null) {
                        meterValue.date = DateTime(date.year, date.month,
                            date.day, time.hour, time.minute);
                        updateCallback!(meterValue);
                      }
                    }
                  },
                ),
              ),
              Flexible(
                child: TextField(
                  controller:
                      TextEditingController(text: meterValue.value.toString()),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(labelText: local.rawValue),
                  onSubmitted: (String v) {
                    meterValue.value = int.tryParse(v) ?? 0;
                    updateCallback!(meterValue);
                  },
                ),
              ),
              Flexible(
                child: TextField(
                  enabled: false,
                  controller: TextEditingController(
                      text: meterValue.correctedValue.toString()),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(labelText: local.correctedValue),
                ),
              ),
              Flexible(
                  child: RemarkButton(
                updateCallback: updateCallback,
                meterValue: meterValue,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
