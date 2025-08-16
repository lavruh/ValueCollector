import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rh_collector/data/dtos/meter_dto.dart';
import 'package:rh_collector/data/services/data_from_service.dart';
import 'package:rh_collector/data/services/fs_selection_service.dart';
import 'package:rh_collector/data/services/info_msg_service.dart';
import 'package:rh_collector/di.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/states/meter_editor_state.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/ui/widgets/export_options_dialog_widget.dart';

enum AllowedFileTypes { csv, bokaPdf }

class DataFromFileState extends GetxController {
  final fs = Get.find<FsSelectionService>();
  DataFromFileService service = Get.find<DataFromFileService>(tag: "csv");
  final filePath = "".obs;
  final msg = Get.find<InfoMsgService>();
  final editor = Get.find<MeterEditorState>();
  final exportFileType = AllowedFileTypes.csv.obs;
  String fileExtension = ".csv";

  initImportData(BuildContext context) async {
    try {
      filePath.value = await fs
          .selectFile(allowedExtensions: ["pdf", "csv"], context: context);
      if (filePath.value.endsWith(".pdf")) {
        service = Get.find<DataFromFileService>(tag: "bokaPdf");
        getDataFromFile(filePath.value);
      } else if (filePath.value.endsWith(".csv")) {
        service = Get.find<DataFromFileService>(tag: "csv");
        getDataFromFile(filePath.value);
      } else {
        msg.push(msg: "Selected file type is not supported❗");
      }
    } on Exception catch (e) {
      msg.push(msg: "Error $e");
    }
  }

  initExportData(BuildContext context) async {
    try {
      await Get.dialog(const ExportOptionsDialogWidget());
      if (exportFileType.value == AllowedFileTypes.csv) {
        service = Get.find<DataFromFileService>(tag: "csv");
        fileExtension = ".csv";
        filePath.value = "";
      } else if (exportFileType.value == AllowedFileTypes.bokaPdf) {
        service = Get.find<DataFromFileService>(tag: "bokaPdf");
        fileExtension = ".pdf";
        filePath.value = await fs.selectFile(
            context: context,
            allowedExtensions: ["pdf"],
            dialogTitle: "Select template to export");
      }
      exportToFile();
    } on Exception catch (e) {
      msg.push(msg: "Error $e");
    }
  }

  getDataFromFile(String filePath) async {
    try {
      String groupId = Get.find<MeterGroups>().getFirstSelectedGroupId();
      try {
        await service.openFile(filePath);
        MetersState metersState = Get.find<MetersState>();
        List dataFromFile = service.getMeters();
        for (MeterDto e in dataFromFile) {
          Meter m = e.copyWith(groupId: groupId).toDomain();
          try {
            m = metersState.getMeter(e.id);
          } catch (err) {
            metersState.addNewMeter(m);
          }

          final editor = Get.find<MeterEditorState>();
          editor.set(m);

          final values = service.getMeterValues(m.id);
          for (final v in values) {
            editor.addValue(v.toDomain());
          }
          metersState.updateMeter(editor.get());
        }
        metersState.update();
        msg.push(msg: "Import done");
      } on Exception catch (e) {
        msg.push(msg: "Import Error, fail open file: $e");
      }
    } on Exception catch (e) {
      msg.push(msg: "Import from file error : $e");
    }
  }

  exportToFile() async {
    MetersState metersState = Get.find<MetersState>();
    String? output = generateFilePath();
    for (Meter m in metersState.meters) {
      try {
        int val = m.getLastValueCorrected();
        service.setMeterDataToExport(meterDto: MeterDto.fromDomain(m));
        service.setMeterReading(meterId: m.id, val: val.toString());
      } on Exception catch (e) {
        msg.push(msg: "Error $e");
        continue;
      }
    }
    try {
      await service.exportData(output: output, template: filePath.value);
    } on Exception catch (e) {
      msg.push(msg: "Error $e");
    }
    msg.push(msg: "Export done to file $output");
  }

  String generateFilePath() {
    return "$appDataPath/readings@${DateFormat("yyyy-MM-dd_ms").format(DateTime.now())}$fileExtension";
  }
}
