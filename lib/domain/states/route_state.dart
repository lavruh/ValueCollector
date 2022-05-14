import 'package:get/get.dart';
import 'package:rh_collector/data/services/fs_selection_service.dart';
import 'package:rh_collector/data/services/info_msg_service.dart';
import 'package:rh_collector/data/services/route_service.dart';
import 'package:rh_collector/domain/states/meters_state.dart';

class RouteState extends GetxController {
  final msg = Get.find<InfoMsgService>();
  final fs = Get.find<FsSelectionService>();
  final routeService = Get.find<RouteService>();
  final meters = Get.find<MetersState>();
  final route = <String>[].obs;
  final doneMeters = <String>[].obs;
  final routeName = "".obs;

  loadRoute() async {
    route.clear();
    doneMeters.clear();
    String path = await fs.selectFile(allowedExtensions: ["csv"]);
    List<String> ids = await routeService.getMetersRoute(path);
    extractRouteName(path);
    for (String id in ids) {
      try {
        meters.getMeter(id);
        route.add(id);
      } catch (e) {
        msg.push(msg: e.toString(), source: "RouteState");
      }
    }
  }

  readingDoneGoNext({required int doneMeterIndex}) {
    String id = route.removeAt(doneMeterIndex);
    doneMeters.insert(0, id);
  }

  extractRouteName(String path) {
    routeName.value =
        path.substring(path.lastIndexOf("/") + 1, path.lastIndexOf("."));
  }
}
