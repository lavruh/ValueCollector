import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/data_from_file_state.dart';

class ExportOptionsDialogWidget extends StatelessWidget {
  const ExportOptionsDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.4,
      widthFactor: 0.8,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Export options",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              GetX<DataFromFileState>(builder: (_) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    RadioListTile(
                        title: const Text("Last values as CSV"),
                        value: AllowedFileTypes.csv,
                        groupValue: _.exportFileType.value,
                        toggleable: true,
                        onChanged: (AllowedFileTypes? value) {
                          _.exportFileType.value = AllowedFileTypes.csv;
                        }),
                    RadioListTile(
                        title: const Text("Boka running hours report"),
                        value: AllowedFileTypes.bokaPdf,
                        groupValue: _.exportFileType.value,
                        toggleable: true,
                        onChanged: (AllowedFileTypes? value) {
                          _.exportFileType.value = AllowedFileTypes.bokaPdf;
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
