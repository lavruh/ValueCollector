import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_group.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';
import 'package:rh_collector/ui/widgets/meter_editor/option_picker_dialog.dart';

class MeterGroupSelectWidget extends StatelessWidget {
  const MeterGroupSelectWidget(
      {super.key, required this.meter, required this.onChanged});
  final Meter meter;
  final Function(Meter) onChanged;

  @override
  Widget build(BuildContext context) {
    final groups = Get.find<MeterGroups>();
    final group = groups.getGroup(meter.groupId);

    if (group == null) return Container();

    return OptionPickerDialog<MeterGroup>(
      initValue: group,
      options: groups.getMeterGroups,
      onChanged: (g) {
        onChanged(meter.copyWith(groupId: g.id));
      },
      titleBuilder: (g) => Text(g.name),
      optionBuilder: (g) => Text(g.name),
    );
  }
}
