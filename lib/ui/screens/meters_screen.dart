import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/ui/widgets/drawer_menu_widget.dart';
import 'package:rh_collector/ui/widgets/meter_widget.dart';
import 'package:rh_collector/ui/widgets/meters_bottom_panel_widget.dart';

class MetersScreen extends StatelessWidget {
  const MetersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<MetersState>().getMeters(Get.find<MeterGroups>().selected);
    return Scaffold(
      appBar: AppBar(
        title: GetX<MeterGroups>(builder: (state) {
          return Text("${state.selected.map((e) => state.getName(e))}");
        }),
        actions: [
          IconButton(
              onPressed: () {
                Get.find<MetersState>().addNewMeter(null);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: GetBuilder<MetersState>(builder: (state) {
        if (state.meters.isNotEmpty) {
          return ListView.builder(
            itemCount: state.meters.length,
            itemBuilder: (BuildContext context, int i) {
              return MeterWidget(
                meter: state.meters[i],
                newReadingSetCallBack: () {
                  state.updateMeter(state.meters[i]);
                },
              );
            },
          );
        } else {
          return Container();
        }
      }),
      bottomNavigationBar: const MetersBottomPanelWidget(),
      resizeToAvoidBottomInset: true,
      drawer: const DrawerMenuWidget(
        key: Key('menu'),
      ),
    );
  }
}
