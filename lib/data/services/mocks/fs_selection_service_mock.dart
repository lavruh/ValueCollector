import 'package:rh_collector/data/services/fs_selection_service.dart';

class FsSelectionServiceMock implements FsSelectionService {
  String filePath = "";

  @override
  Future<String> selectFile({List<String>? allowedExtensions}) async {
    return filePath;
  }
}
