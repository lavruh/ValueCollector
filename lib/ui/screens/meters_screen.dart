import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/ui/widgets/meter_widget.dart';
import 'package:rh_collector/ui/widgets/meters_bottom_panel_widget.dart';

// TODO change groups

class MetersScreen extends StatefulWidget {
  const MetersScreen({Key? key}) : super(key: key);

  @override
  _MetersScreenState createState() => _MetersScreenState();
}

class _MetersScreenState extends State<MetersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Get.find<MetersState>().updateMeter(Meter(
                  name: "name",
                  groupId: Get.find<MeterGroups>().selected.first,
                ));
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: GetBuilder<MetersState>(builder: (_) {
        _.getMeters(Get.find<MeterGroups>().selected);
        if (_.meters.isNotEmpty) {
          return ListView.builder(
            itemCount: _.meters.length,
            itemBuilder: (BuildContext context, int i) {
              return MeterWidget(meter: _.meters[i]);
            },
          );
        } else {
          return Container();
        }
      }),
      bottomSheet: const MetersBottomPanalWidget(),
      drawer: Drawer(
        child: Wrap(),
      ),
    );
  }
}
