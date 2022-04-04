import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/route_state.dart';
import 'package:rh_collector/ui/widgets/meter_widget.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({Key? key}) : super(key: key);

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
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "ToDo",
              ),
              Tab(
                text: "Done",
              )
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
                      meterId: _.route[i],
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
                  reverse: true,
                  itemCount: _.doneMeters.length,
                  itemBuilder: (BuildContext context, int i) {
                    return MeterWidget(
                      meterId: _.doneMeters[i],
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
