abstract class DbService {
  String currentTable = "main";
  DbService({required String dbName, String? path});
  addEntry(Map<String, dynamic> entry);
  updateEntry(Map<String, dynamic> entry);
  removeEntry(String id);
  Future<List<Map<String, dynamic>>> getEntries(List<List<dynamic>> request);
  selectTable(String tableName);
  clearDb();
}
