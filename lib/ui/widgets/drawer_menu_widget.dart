import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            onTap: () async {},
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: Text(
              "Export to file",
              style: textTheme,
            ),
            onTap: () async {},
          ),
        ],
      ),
    );
  }
}