abstract class DbService {
  openDb({required String dbName, String? path});
  addEntry(Map<String, dynamic> entry);
  updateEntry(Map<String, dynamic> entry);
  removeEntry(String id);
  List<Map<String, dynamic>> getEntries(List<List<dynamic>> request);
}
