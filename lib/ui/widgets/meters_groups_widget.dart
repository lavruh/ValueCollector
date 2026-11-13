import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter_group.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';
import 'package:rh_collector/l10n/app_localizations.dart';

class MetersGroupsWidget extends StatelessWidget {
  MetersGroupsWidget({super.key});
  final state = Get.find<MeterGroups>();
  final isMultiSelectMode = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.meterGroups),
        actions: [
          IconButton(
            onPressed: _addNewGroup,
            icon: const Icon(Icons.add),
          ),
          Obx(
            () => IconButton(
              tooltip: isMultiSelectMode.value
                  ? "Multi-select mode"
                  : "Single-select mode",
              onPressed: () {
                isMultiSelectMode.value = !isMultiSelectMode.value;
              },
              icon: Icon(
                isMultiSelectMode.value
                    ? Icons.check_box
                    : Icons.radio_button_checked,
              ),
              color: isMultiSelectMode.value
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
          ),
          Obx(
            () => IconButton(
              onPressed: state.toggleMode,
              icon: Icon(
                state.editMode.value ? Icons.done : Icons.edit,
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          final isEditing = state.editMode.value;
          final groupsList = state.groups.values.toList();
          return ListView.builder(
            itemCount: groupsList.length,
            itemBuilder: (context, index) {
              final itm = groupsList[index];
              if (isEditing) {
                return ListTile(
                  title: TextField(
                    controller: TextEditingController(text: itm.name),
                    onSubmitted: (s) =>
                        state.updateGroup(MeterGroup(name: s, id: itm.id)),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => state.deleteGroup(itm.id),
                  ),
                );
              } else {
                return Obx(
                  () => ListTile(
                    leading: Checkbox(
                      value: state.isSelected(itm),
                      onChanged: (bool? v) {
                        if (isMultiSelectMode.value) {
                          state.toggleGroupSelect(itm);
                        } else {
                          state.selectSingleGroup(itm);
                        }
                      },
                    ),
                    title: Text(itm.name),
                    onTap: () {
                      if (isMultiSelectMode.value) {
                        state.toggleGroupSelect(itm);
                      } else {
                        state.selectSingleGroup(itm);
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                  ),
                );
              }
            },
          );
        },
      ),
      floatingActionButton: Obx(
        () => isMultiSelectMode.value
            ? FloatingActionButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Icon(Icons.check),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  _addNewGroup() {
    state.addGroup(MeterGroup(name: "name"));
  }
}
