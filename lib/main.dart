import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:impariamo/src/di/injection.dart';
import 'package:impariamo/src/router/app_router.dart';

/// The entry point for the Impariamo application.
///
/// This function initializes necessary core services before running the app.
/// Specifically, it:
/// - Ensures Flutter bindings are initialized.
/// - Initializes the local Hive storage.
/// - Sets up Dependency Injection via `get_it`.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  configureDependencies();
  runApp(const MyApp());
}

/// The root application widget.
///
/// Configures the global [MaterialApp] settings including routing
/// (via `go_router`) and the application's base theme.
class MyApp extends StatelessWidget {
  /// Creates the root [MyApp] widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Impariamo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: appRouter,
    );
  }
}
