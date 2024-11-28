import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';

class MeterGroupSelectWidget extends StatelessWidget {
  const MeterGroupSelectWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = Get.find<MeterGroups>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Group:"),
        ),
        GetX<Meter>(
            tag: "meterEdit",
            builder: (state) {
              return DropdownButton<String>(
                  hint: const Text("Group:"),
                  value: state.groupId,
                  items: groups.getMeterGroups
                      .map((group) => DropdownMenuItem<String>(
                            value: group.id,
                            child: Text(group.name),
                          ))
                      .toList(),
                  onChanged: _updateMeterGroup);
            }),
      ],
    );
  }

  void _updateMeterGroup(String? value) {
    if (value != null) {
      Get.find<Meter>(tag: "meterEdit").groupId = value;
    }
  }
}
