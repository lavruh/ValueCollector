import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/domain/states/route_state.dart';
import 'package:rh_collector/ui/widgets/meter_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            final title = _.routeName.value.length > 1
                ? _.routeName.value
                : AppLocalizations.of(context)!.openRouteFile;
            return Text(title);
          }),
          actions: [
            IconButton(
                onPressed: _loadRoute, icon: const Icon(Icons.get_app_outlined))
          ],
          bottom: TabBar(
            tabs: [
              GetX<RouteState>(builder: (_) {
                return Tab(
                    text: AppLocalizations.of(context)!.todo +
                        "(${_.route.length})");
              }),
              GetX<RouteState>(builder: (_) {
                return Tab(
                    text: AppLocalizations.of(context)!.done +
                        "(${_.doneMeters.length})");
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
