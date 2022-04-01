import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/di.dart';
import 'package:rh_collector/domain/states/data_from_file_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/ui/widgets/meters_groups_widget.dart';

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
              "Meters Groups",
              style: textTheme,
            ),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      const MetersGroupsWidget());
              Get.find<MetersState>().update();
            },
          ),
          ListTile(
            leading: const Icon(Icons.timeline_outlined),
            title: Text(
              "Routes",
              style: textTheme,
            ),
            onTap: () async {},
          ),
          ListTile(
            leading: const Icon(Icons.login_outlined),
            title: Text(
              "Import from file",
              style: textTheme,
            ),
            subtitle: GetX<DataFromFileState>(builder: (_) {
              return Text(_.filePath.value.toString());
            }),
            onTap: () async {
              Get.find<DataFromFileState>().initImportData();
            },
          ),
          GetX<DataFromFileState>(builder: (_) {
            return ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: Text(
                "Export to file",
                style: textTheme,
              ),
              subtitle: _.exportAlowed.value
                  ? Text("Export to $appDataPath")
                  : const Text("Select export template file"),
              onTap: () async {
                _.initExportData();
              },
            );
          }),
        ],
      ),
    );
  }
}
