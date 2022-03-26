import 'package:get/get.dart';
import 'package:rh_collector/data/services/info_msg_service.dart';

class SnackbarInfoMsgService implements InfoMsgService {
  @override
  push({required String msg, String? source}) {
    Get.snackbar(source ?? "", msg);
  }
}
