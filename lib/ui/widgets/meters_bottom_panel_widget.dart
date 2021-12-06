import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/ui/widgets/meters_groups_widget.dart';

class MetersBottomPanalWidget extends StatelessWidget {
  const MetersBottomPanalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          const MetersGroupsWidget());
                  Get.find<MetersState>().update();
                },
                icon: const Icon(Icons.checklist_outlined)),
            // TODO make autofill hints
            FractionallySizedBox(
              widthFactor: 0.6,
              child: TextField(
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                  icon: const Icon(Icons.manage_search_outlined),
                  onPressed: () {},
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
