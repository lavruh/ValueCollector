import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter_group.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MetersGroupsWidget extends StatelessWidget {
  MetersGroupsWidget({super.key});
  final _state = Get.find<MeterGroups>();

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
                      onPressed: _state.toggleMode,
                      icon: const Icon(Icons.edit)),
                ],
              ),
            ],
          ),
          GetX<MeterGroups>(builder: (_) {
            final checkBoxes = <Widget>[];

            for (MeterGroup itm in _.groups.values) {
              if (_.editMode.value) {
                checkBoxes.add(ListTile(
                  title: TextField(
                    controller: TextEditingController(text: itm.name),
                    onSubmitted: (s) =>
                        _.updateGroup(MeterGroup(name: s, id: itm.id)),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _.deleteGroup(itm.id),
                  ),
                ));
              } else {
                checkBoxes.add(
                  CheckboxListTile(
                    value: _.isSelected(itm),
                    onChanged: (bool? v) {
                      _.toggleGroupSelect(itm);
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
    _state.addGroup(MeterGroup(name: "name"));
  }
}
