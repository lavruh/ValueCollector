import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/di.dart';
import 'package:rh_collector/domain/states/data_from_file_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/ui/screens/meter_rates_edit_screen.dart';
import 'package:rh_collector/ui/screens/meter_type_edit_screen.dart';
import 'package:rh_collector/ui/screens/reminders_screen.dart';
import 'package:rh_collector/ui/screens/route_screen.dart';
import 'package:rh_collector/ui/widgets/meters_groups_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrawerMenuWidget extends StatelessWidget {
  const DrawerMenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.headline5;
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.checklist_outlined),
            title: Text(
              AppLocalizations.of(context)!.meterGroups,
              style: textTheme,
            ),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) => MetersGroupsWidget());
              Get.find<MetersState>().update();
            },
          ),
          ListTile(
            leading: const Icon(Icons.timeline_outlined),
            title: Text(
              AppLocalizations.of(context)!.routes,
              style: textTheme,
            ),
            onTap: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RouteScreen()));
              Get.find<MetersState>().update();
            },
          ),
          ListTile(
            leading: const Icon(Icons.request_page),
            title: Text(
              AppLocalizations.of(context)!.meterRates,
              style: textTheme,
            ),
            onTap: () {
              Get.to(() => const MeterRatesEditScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.electric_meter),
            title: Text(
              AppLocalizations.of(context)!.meterTypes,
              style: textTheme,
            ),
            onTap: () {
              Get.to(() => const MeterTypeEditScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(
              AppLocalizations.of(context)!.reminders,
              style: textTheme,
            ),
            onTap: () => Get.to(() => const RemindersScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.login_outlined),
            title: Text(
              AppLocalizations.of(context)!.import,
              style: textTheme,
            ),
            subtitle: GetX<DataFromFileState>(builder: (_) {
              return Text(_.filePath.value.toString());
            }),
            onTap: () async {
              Get.find<DataFromFileState>().initImportData();
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: Text(
              AppLocalizations.of(context)!.export,
              style: textTheme,
            ),
            subtitle: Text(
                AppLocalizations.of(context)!.exportedTo + " $appDataPath"),
            onTap: () async {
              Get.find<DataFromFileState>().initExportData();
            },
          ),
        ],
      ),
    );
  }
}
