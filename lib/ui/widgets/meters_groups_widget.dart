import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter_group.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';
import 'package:rh_collector/l10n/app_localizations.dart';

class MetersGroupsWidget extends StatelessWidget {
  MetersGroupsWidget({super.key});
  final state = Get.find<MeterGroups>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(),
      backgroundColor: Colors.transparent,
      child: Card(
          child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.meterGroups,
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: _addNewGroup, icon: const Icon(Icons.add)),
                  IconButton(
                      onPressed: state.toggleMode,
                      icon: const Icon(Icons.edit)),
                ],
              ),
            ],
          ),
          GetX<MeterGroups>(builder: (state) {
            final checkBoxes = <Widget>[];

            for (MeterGroup itm in state.groups.values) {
              if (state.editMode.value) {
                checkBoxes.add(ListTile(
                  title: TextField(
                    controller: TextEditingController(text: itm.name),
                    onSubmitted: (s) =>
                        state.updateGroup(MeterGroup(name: s, id: itm.id)),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => state.deleteGroup(itm.id),
                  ),
                ));
              } else {
                checkBoxes.add(
                  CheckboxListTile(
                    value: state.isSelected(itm),
                    onChanged: (bool? v) {
                      state.toggleGroupSelect(itm);
                    },
                    title: Text(itm.name),
                  ),
                );
              }
            }

            return Column(
              children: checkBoxes,
            );
          }),
        ],
      )),
    );
  }

  _addNewGroup() {
    state.addGroup(MeterGroup(name: "name"));
  }
}
