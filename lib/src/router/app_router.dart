import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:impariamo/03_contiamo/02_domain/repositories/time_tables_progress_repository.dart';
import 'package:impariamo/03_contiamo/03_presentation/pages/mini_games.dart';
import 'package:impariamo/03_contiamo/03_presentation/pages/table_choice.dart';
import 'package:impariamo/03_contiamo/03_presentation/pages/table_input.dart';
import 'package:impariamo/03_contiamo/03_presentation/pages/guess_table_page.dart';

final getIt = GetIt.instance;

class AppRoutes {
  static const home = '/';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) =>  MiniGames(),
    ),
    GoRoute(
      path: TableChoice.route,
      builder: (context, state) => TableChoice(
        progressRepository: getIt<TimeTablesProgressRepository>(instanceName: 'TableChoiceRepository'),
      ),
    ),
    GoRoute(
      path: TableInput.route,
      builder: (context, state) => TableInput(
        progressRepository: getIt<TimeTablesProgressRepository>(instanceName: 'TableInputRepository'),
      ),
    ),
    GoRoute(
      path: GuessTablePage.route,
      builder: (context, state) => const GuessTablePage(),
    ),
  ],
);
