abstract class FsSelectionService {
  Future<String> selectFile(
      {List<String>? allowedExtensions, String? dialogTitle});
}
