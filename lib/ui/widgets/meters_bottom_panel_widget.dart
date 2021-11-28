import 'package:flutter/material.dart';
import 'package:rh_collector/ui/widgets/meters_groups_widget.dart';

class MetersBottomPanalWidget extends StatelessWidget {
  const MetersBottomPanalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Wrap(
        // TODO make card fill 100% width
        alignment: WrapAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        const MetersGroupsWidget());
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
    );
  }
}
