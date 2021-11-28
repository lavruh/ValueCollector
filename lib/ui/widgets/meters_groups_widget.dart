import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter_group.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';

// TODO Add new group field

class MetersGroupsWidget extends StatelessWidget {
  const MetersGroupsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(),
      backgroundColor: Colors.transparent,
      child: Card(
          child: Wrap(
        children: [
          Text(
            "Groups :",
            style: Theme.of(context).textTheme.headline5,
          ),
          GetBuilder<MeterGroups>(builder: (_) {
            final checkBoxes = <Widget>[];

            for (MeterGroup itm in _.groups.values) {
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

            return Column(
              children: checkBoxes,
            );
          }),
        ],
      )),
    );
  }
}
