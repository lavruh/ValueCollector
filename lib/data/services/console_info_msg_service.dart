import 'package:rh_collector/data/services/info_msg_service.dart';

class ConsoleInfoMsgService implements InfoMsgService {
  @override
  push({required String msg, String? source}) {
    print("INFO $source -> $msg");
  }
}
