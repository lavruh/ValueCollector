abstract class DbService {
  bool isLoaded = false;
  DbService({required String dbName, String? path});
  openDb();
  addEntry(Map<String, dynamic> entry, {required String table});
  updateEntry(Map<String, dynamic> entry, {required String table});
  removeEntry(String id, {required String table});
  Future<List<Map<String, dynamic>>> getEntries(List<List<dynamic>> request,
      {required String table});
  clearDb({required String table});
}
