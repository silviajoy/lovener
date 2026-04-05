import 'package:hive_flutter/hive_flutter.dart';

class HiveTimeTablesProgressDataSource {
  static const _boxName = 'time_tables_progress';

  Future<Box<Map>> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<Map>(_boxName);
    }

    return Hive.openBox<Map>(_boxName);
  }

  Future<List<Map>> loadStoredTimeTablesProgressRows() async {
    final box = await _openBox();
    return box.values.cast<Map>().toList();
  }

  Future<void> storeTimeTablesProgressRows(List<Map> values) async {
    final box = await _openBox();
    await box.clear();

    for (var index = 0; index < values.length; index++) {
      await box.put(index, values[index]);
    }
  }

  Future<void> clearStoredTimeTablesProgressRows() async {
    final box = await _openBox();
    await box.clear();
  }
}