import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/domain/states/route_state.dart';
import 'package:rh_collector/ui/widgets/meter_widget.dart';
import 'package:rh_collector/l10n/app_localizations.dart';

class RouteScreen extends StatelessWidget {
  RouteScreen({super.key});
  final metersState = Get.find<MetersState>();

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    if (local == null) return const Center(child: CircularProgressIndicator());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: GetX<RouteState>(builder: (state) {
            final title = state.routeName.value.length > 1
                ? state.routeName.value
                : local.openRouteFile;
            return Text(title);
          }),
          actions: [
            IconButton(
                onPressed: _loadRoute, icon: const Icon(Icons.get_app_outlined))
          ],
          bottom: TabBar(
            tabs: [
              GetX<RouteState>(builder: (state) {
                return Tab(text: "${local.todo}(${state.route.length})");
              }),
              GetX<RouteState>(builder: (state) {
                return Tab(text: "${local.done}(${state.doneMeters.length})");
              })
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GetX<RouteState>(
              builder: (state) {
                return ListView.builder(
                  itemCount: state.route.length,
                  itemBuilder: (BuildContext context, int i) {
                    return MeterWidget(
                      meter: metersState.getMeter(state.route[i]),
                      newReadingSetCallBack: () {
                        state.readingDoneGoNext(doneMeterIndex: i);
                      },
                      suffix: IconButton(
                        tooltip: "Postpone",
                        onPressed: () =>
                            state.postponeReading(postponeMeterIndex: i),
                        icon: const Icon(Icons.move_down),
                      ),
                    );
                  },
                );
              },
            ),
            GetX<RouteState>(
              builder: (state) {
                return ListView.builder(
                  itemCount: state.doneMeters.length,
                  itemBuilder: (BuildContext context, int i) {
                    return MeterWidget(
                      meter: metersState.getMeter(state.doneMeters[i]),
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
