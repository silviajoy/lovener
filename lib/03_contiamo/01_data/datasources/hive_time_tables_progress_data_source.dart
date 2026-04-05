import 'package:hive_flutter/hive_flutter.dart';
import '../models/hive_progress_model.dart';

class HiveTimeTablesProgressDataSource {
  final String boxName;

  HiveTimeTablesProgressDataSource({this.boxName = 'time_tables_progress'});

  Future<Box<Map>> _openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Map>(boxName);
    }

    return Hive.openBox<Map>(boxName);
  }

  Future<List<HiveProgressModel>> loadStoredTimeTablesProgressRows() async {
    final box = await _openBox();
    return box.values
        .cast<Map>()
        .map((row) => HiveProgressModel.fromMap(row))
        .toList();
  }

  Future<void> storeTimeTablesProgressRows(List<HiveProgressModel> values) async {
    final box = await _openBox();
    await box.clear();

    for (var index = 0; index < values.length; index++) {
      await box.put(index, values[index].toMap());
    }
  }

  Future<void> clearStoredTimeTablesProgressRows() async {
    final box = await _openBox();
    await box.clear();
  }
}
