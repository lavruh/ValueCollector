import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/data_from_file_state.dart';
import 'package:rh_collector/l10n/app_localizations.dart';

class ExportOptionsDialogWidget extends StatelessWidget {
  const ExportOptionsDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    if (local == null) return Center(child: CircularProgressIndicator());
    return FractionallySizedBox(
      heightFactor: 0.4,
      widthFactor: 0.8,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(local.exportOptions),
              GetX<DataFromFileState>(builder: (state) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    RadioListTile(
                        title: Text(local.lastInCsv),
                        value: AllowedFileTypes.csv,
                        groupValue: state.exportFileType.value,
                        toggleable: true,
                        onChanged: (AllowedFileTypes? value) {
                          state.exportFileType.value = AllowedFileTypes.csv;
                        }),
                  ],
                );
              }),
              IconButton(
                  onPressed: () => Get.back(), icon: const Icon(Icons.check))
            ],
          ),
        ),
      ),
    );
  }
}
