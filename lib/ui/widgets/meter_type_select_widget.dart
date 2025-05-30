import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/meter_types_state.dart';

class MeterTypeSelectWidget extends StatelessWidget {
  MeterTypeSelectWidget(
      {super.key, required this.initValueId, required this.callback});
  final meterTypesState = Get.find<MeterTypesState>();
  final String initValueId;
  final Function(String val) callback;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      icon: const Icon(Icons.arrow_drop_down),
      value: meterTypesState.isExists(initValueId) ? initValueId : "rh",
      elevation: 3,
      items: meterTypesState
          .getMeterTypesList()
          .map((e) => DropdownMenuItem<String>(
                value: e.id,
                child: Row(
                  children: [
                    Icon(
                      meterTypesState.getIcon(e.iconCode),
                      color: Color(e.color),
                    ),
                    Text(e.name),
                  ],
                ),
              ))
          .toList(),
      onChanged: (value) {
        callback(value ?? initValueId);
      },
    );
  }
}
