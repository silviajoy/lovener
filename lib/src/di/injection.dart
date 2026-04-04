import 'package:get_it/get_it.dart';
import 'package:impariamo/03_contiamo/01_data/repositories/time_tables_progress_repository_impl.dart';
import 'package:impariamo/03_contiamo/02_domain/repositories/time_tables_progress_repository.dart';


final getIt = GetIt.instance;

void configureDependencies() {
  getIt.registerLazySingleton<TimeTablesProgressRepository>(
    () => MockTimeTablesProgressRepositoryImpl(),
  );
}