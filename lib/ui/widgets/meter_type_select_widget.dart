import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter_type.dart';
import 'package:rh_collector/domain/states/meter_types_state.dart';
import 'package:rh_collector/ui/widgets/meter_editor/option_picker_dialog.dart';

class MeterTypeSelectWidget extends StatelessWidget {
  MeterTypeSelectWidget(
      {super.key, required this.initValueId, required this.callback});
  final meterTypesState = Get.find<MeterTypesState>();
  final String initValueId;
  final Function(String val) callback;

  @override
  Widget build(BuildContext context) {
    final initValue = meterTypesState.getMeterTypeById(initValueId);

    return OptionPickerDialog<MeterType>(
        initValue: initValue,
        options: meterTypesState.getMeterTypesList(),
        onChanged: (type) {
          callback(type.id);
        },
        titleBuilder: (e) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(meterTypesState.getIcon(e.iconCode),
                    color: Color(e.color)),
                Text(e.name)
              ],
            ),
        optionBuilder: (e) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(meterTypesState.getIcon(e.iconCode),
                    color: Color(e.color)),
                Text(e.name)
              ],
            ));
  }
}
