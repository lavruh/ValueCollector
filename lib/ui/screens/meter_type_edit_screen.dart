import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter_type.dart';
import 'package:rh_collector/domain/states/meter_types_state.dart';
import 'package:rh_collector/ui/widgets/meter_type_edit_widget.dart';

class MeterTypeEditScreen extends StatelessWidget {
  const MeterTypeEditScreen({Key? key}) : super(key: key);

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
                child: MeterTypeEditWidget(
                  meterType: type,
                  updateCallback: (t) => state.updateMeterType(t),
                ),
                endActionPane:
                    ActionPane(motion: const ScrollMotion(), children: [
                  SlidableAction(
                      icon: Icons.delete_forever,
                      backgroundColor: Colors.red,
                      onPressed: (BuildContext context) {
                        state.removeMeterType(type.id);
                      }),
                ]));
          },
        );
      }),
    );
  }

  void _addMeterType() {
    Get.find<MeterTypesState>().addMeterType(MeterType(name: 'name'));
  }
}
