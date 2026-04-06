import 'package:get_it/get_it.dart';
import 'package:impariamo/03_contiamo/01_data/datasources/hive_time_tables_progress_data_source.dart';
import 'package:impariamo/03_contiamo/01_data/datasources/hive_guess_table_progress_data_source.dart';
import 'package:impariamo/03_contiamo/01_data/repositories/hive_time_tables_progress_repository_impl.dart';
import 'package:impariamo/03_contiamo/01_data/repositories/time_tables_progress_repository_impl.dart';
import 'package:impariamo/03_contiamo/02_domain/repositories/time_tables_progress_repository.dart';

/// The global [GetIt] instance for Dependency Injection.
final getIt = GetIt.instance;

/// Configures all application dependencies.
///
/// Registers repositories and services into the service locator (`getIt`).
/// Supports a mock mode for UI testing, activated via `--dart-define=MOCK_MODE=true`.
///
/// Each game mode receives a named instance of [TimeTablesProgressRepository]
/// to separate their progress data sets in local storage via different Hive boxes.
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

  getIt.registerLazySingleton<TimeTablesProgressRepository>(() {
    if (useMockStorage) {
      return MockTimeTablesProgressRepositoryImpl();
    }
    return HiveTimeTablesProgressRepositoryImpl(
      HiveTimeTablesProgressDataSource(boxName: 'time_tables_progress'),
      guessDataSource: HiveGuessTableProgressDataSource(boxName: 'guess_table_progress'),
    );
  }, instanceName: 'GuessTableRepository');
}
