import 'package:flutter/material.dart';
import 'package:rh_collector/l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter_type.dart';
import 'package:rh_collector/domain/states/meter_types_state.dart';
import 'package:rh_collector/ui/widgets/meter_type_edit_widget.dart';

class MeterTypeEditScreen extends StatelessWidget {
  const MeterTypeEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.meterTypes),
        actions: [
          IconButton(onPressed: _addMeterType, icon: const Icon(Icons.add))
        ],
      ),
      body: GetX<MeterTypesState>(builder: (state) {
        final typesList = state.getMeterTypesList();
        return ListView.builder(
          itemCount: state.meterTypes.length,
          itemBuilder: (context, index) {
            final type = typesList[index];
            return Slidable(
                endActionPane:
                    ActionPane(motion: const ScrollMotion(), children: [
                  SlidableAction(
                      icon: Icons.delete_forever,
                      backgroundColor: Colors.red,
                      onPressed: (BuildContext context) {
                        state.removeMeterType(type.id);
                      }),
                ]),
                child: MeterTypeEditWidget(
                  meterType: type,
                  updateCallback: (t) => state.updateMeterType(t),
                ));
          },
        );
      }),
    );
  }

  void _addMeterType() {
    Get.find<MeterTypesState>().addMeterType(MeterType(name: 'name'));
  }
}
