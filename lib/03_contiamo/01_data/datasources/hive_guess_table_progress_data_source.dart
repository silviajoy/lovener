import 'package:hive_flutter/hive_flutter.dart';
import '../models/hive_guess_table_progress_model.dart';

class HiveGuessTableProgressDataSource {
  final String boxName;

  HiveGuessTableProgressDataSource({this.boxName = 'guess_table_progress'});

  Future<Box<Map>> _openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Map>(boxName);
    }

    return Hive.openBox<Map>(boxName);
  }

  Future<List<HiveGuessTableProgressModel>> loadStoredGuessTableProgressRows() async {
    final box = await _openBox();
    return box.values
        .cast<Map>()
        .map((row) => HiveGuessTableProgressModel.fromMap(row))
        .toList();
  }

  Future<void> storeGuessTableProgressRows(List<HiveGuessTableProgressModel> values) async {
    final box = await _openBox();
    await box.clear();

    for (var index = 0; index < values.length; index++) {
      await box.put(index, values[index].toMap());
    }
  }

  Future<void> clearStoredGuessTableProgressRows() async {
    final box = await _openBox();
    await box.clear();
  }
}
