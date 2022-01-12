import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:rh_collector/data/services/data_from_service.dart';
import 'package:rh_collector/di.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/states/meter_groups_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';

class DataFromFileState extends GetxController {
  final service = Get.find<DataFromFileService>();
  String filePath = "";

  initImportData() async {
    FilePickerResult? r = await FilePicker.platform.pickFiles();
    if (r != null) {
      filePath = r.files.single.path!;
      getDataFromFile(filePath);
    }
  }

  getDataFromFile(String filePath) async {
    MetersState metersState = Get.find<MetersState>();
    List selectedGroupIds = Get.find<MeterGroups>().selected;
    late String groupId;
    if (selectedGroupIds.isNotEmpty) {
      groupId = Get.find<MeterGroups>().selected.first;
    } else {
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
      m.addValue(MeterValue(e["date"], e["reading"]));
    }
    metersState.update();
    metersState.notifyChildrens();
    Get.snackbar("Import", "Done");
  }

  exportToFile() async {
    MetersState metersState = Get.find<MetersState>();
    String? output = appDataPath +
        "/readings@" +
        DateFormat("yyyy-MM-dd_ms").format(DateTime.now()) +
        ".pdf";
    for (Meter m in metersState.meters) {
      try {
        int val = 0;
        Meter t = Get.find<Meter>(tag: m.id);
        if (t.values.isNotEmpty) {
          val = t.values.last.value;
        }
        service.setMeterReading(meterId: m.id, val: val.toString());
      } on Exception catch (e) {
        Get.snackbar("Error", e.toString());
        continue;
      }
    }
    service.exportData(outputPath: output);
    Get.snackbar("Export", "Done");
  }
}
