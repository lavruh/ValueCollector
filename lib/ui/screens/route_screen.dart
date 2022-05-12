import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/domain/states/route_state.dart';
import 'package:rh_collector/ui/widgets/meter_widget.dart';

class RouteScreen extends StatelessWidget {
  RouteScreen({Key? key}) : super(key: key);
  final metersState = Get.find<MetersState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: GetX<RouteState>(builder: (_) {
            return Text(_.routeName.value);
          }),
          actions: [
            IconButton(
                onPressed: _loadRoute, icon: const Icon(Icons.get_app_outlined))
          ],
          bottom: TabBar(
            tabs: [
              GetX<RouteState>(builder: (_) {
                return Tab(text: "ToDo(${_.route.length})");
              }),
              GetX<RouteState>(builder: (_) {
                return Tab(text: "Done(${_.doneMeters.length})");
              })
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GetX<RouteState>(
              builder: (_) {
                return ListView.builder(
                  itemCount: _.route.length,
                  itemBuilder: (BuildContext context, int i) {
                    return MeterWidget(
                      meter: metersState.getMeter(_.route[i]),
                      newReadingSetCallBack: () {
                        _.readingDoneGoNext(doneMeterIndex: i);
                      },
                    );
                  },
                );
              },
            ),
            GetX<RouteState>(
              builder: (_) {
                return ListView.builder(
                  itemCount: _.doneMeters.length,
                  itemBuilder: (BuildContext context, int i) {
                    return MeterWidget(
                      meter: metersState.getMeter(_.doneMeters[i]),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _loadRoute() {
    Get.find<RouteState>().loadRoute();
  }
}
