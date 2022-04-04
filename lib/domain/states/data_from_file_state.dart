import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rh_collector/data/services/data_from_service.dart';
import 'package:rh_collector/data/services/fs_selection_service.dart';
import 'package:rh_collector/data/services/info_msg_service.dart';
import 'package:rh_collector/di.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';

class DataFromFileState extends GetxController {
  final fs = Get.find<FsSelectionService>();
  final service = Get.find<DataFromFileService>();
  final filePath = "".obs;
  final exportAlowed = false.obs;
  final msg = Get.find<InfoMsgService>();

  initImportData() async {
    try {
      filePath.value = await fs.selectFile(allowedExtensions: ["pdf"]);
      getDataFromFile(filePath.value);
    } on Exception catch (e) {
      msg.push(msg: "Error $e");
    }
  }

  initExportData() async {
    try {
      filePath.value = await fs.selectFile(allowedExtensions: ["pdf"]);
      exportAlowed.value = true;
      exportToFile();
    } on Exception catch (e) {
      msg.push(msg: "Error $e");
    }
  }

  getDataFromFile(String filePath) async {
    MetersState metersState = Get.find<MetersState>();
    List selectedGroupIds = Get.find<MeterGroups>().selected;
    late String groupId;
    if (selectedGroupIds.isNotEmpty) {
      groupId = Get.find<MeterGroups>().selected.first;
    } else {
      msg.push(msg: "No meter group selected");
      throw Exception("No meter group selected");
    }
    await service.openFile(filePath);
    List dataFromFile = service.getMeters();
    for (Map e in dataFromFile) {
      late Meter m;
      try {
        m = Get.find(tag: e["id"]);
      } catch (err) {
        m = Meter(id: e["id"], name: e["name"], groupId: groupId);
        metersState.addNewMeter(m);
      }
      m.addValue(MeterValue(e["date"], e["reading"], correct: 0));
    }
    metersState.update();
    metersState.notifyChildrens();
    exportAlowed.value = true;
    msg.push(msg: "Import done");
  }

  exportToFile() async {
    MetersState metersState = Get.find<MetersState>();
    String? output = appDataPath +
        "/readings@" +
        DateFormat("yyyy-MM-dd_ms").format(DateTime.now()) +
        ".pdf";
    for (Meter m in metersState.meters) {
      try {
        int val = Get.find<Meter>(tag: m.id).getLastValueCorrected();
        service.setMeterReading(meterId: m.id, val: val.toString());
      } on Exception catch (e) {
        msg.push(msg: "Error $e");
        continue;
      }
    }
    try {
      await service.setFilePath(filePath.value);
      await service.exportData(outputPath: output);
    } on Exception catch (e) {
      msg.push(msg: "Error $e");
    }
    msg.push(msg: "Export done to file $output");
  }
}
