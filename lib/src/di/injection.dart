import 'package:get_it/get_it.dart';
import 'package:impariamo/03_contiamo/01_data/datasources/hive_time_tables_progress_data_source.dart';
import 'package:impariamo/03_contiamo/01_data/repositories/hive_time_tables_progress_repository_impl.dart';
import 'package:impariamo/03_contiamo/01_data/repositories/time_tables_progress_repository_impl.dart';
import 'package:impariamo/03_contiamo/02_domain/repositories/time_tables_progress_repository.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  const useMockStorage = bool.fromEnvironment('MOCK_MODE', defaultValue: false);

  getIt.registerLazySingleton<TimeTablesProgressRepository>(() {
    if (useMockStorage) {
      return MockTimeTablesProgressRepositoryImpl();
    }
    return HiveTimeTablesProgressRepositoryImpl(
      HiveTimeTablesProgressDataSource(boxName: 'time_tables_progress'),
    );
  }, instanceName: 'TableChoiceRepository');

  getIt.registerLazySingleton<TimeTablesProgressRepository>(() {
    if (useMockStorage) {
      return MockTimeTablesProgressRepositoryImpl();
    }
    return HiveTimeTablesProgressRepositoryImpl(
      HiveTimeTablesProgressDataSource(boxName: 'time_tables_input_progress'),
    );
  }, instanceName: 'TableInputRepository');
}
