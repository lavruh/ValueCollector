import 'package:file_picker/file_picker.dart';
import 'package:rh_collector/data/services/fs_selection_service.dart';

class FilePickerSelectionService implements FsSelectionService {
  @override
  Future<String> selectFile(
      {List<String>? allowedExtensions, String? dialogTitle}) async {
    FileType ft = FileType.any;
    if (allowedExtensions != null) {
      ft = FileType.custom;
    }
    FilePickerResult? r = await FilePicker.platform.pickFiles(
      type: ft,
      allowedExtensions: allowedExtensions,
      dialogTitle: dialogTitle,
    );
    if (r != null) {
      return r.files.single.path!;
    }
    throw Exception("No file selected");
  }
}
