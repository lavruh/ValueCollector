import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/ui/widgets/meters_groups_widget.dart';

class MetersBottomPanalWidget extends StatelessWidget {
  MetersBottomPanalWidget({Key? key}) : super(key: key);
  TextEditingController filterInputTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Wrap(
          children: [
            IconButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) => MetersGroupsWidget());
                },
                icon: const Icon(Icons.checklist_outlined)),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: TextField(
                  controller: filterInputTextController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                    icon: const Icon(Icons.close_outlined),
                    onPressed: () {
                      filterInputTextController.clear();
                      Get.find<MetersState>().filterMetersByName(
                        filter: "",
                        groupId: Get.find<MeterGroups>().selected,
                      );
                    },
                  )),
                  onChanged: (String newText) {
                    Get.find<MetersState>().filterMetersByName(
                      filter: newText,
                      groupId: Get.find<MeterGroups>().selected,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
