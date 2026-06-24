import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'data/database.dart';
import 'ui/app_shell.dart';
import 'ui/theme.dart';
import 'ui/theme_controller.dart';
import 'ui/verrou.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  final db = AppDatabase();
  final theme = ThemeController();
  await theme.charger();
  final verrou = VerrouController(db);
  await verrou.charger();
  runApp(EscaleApp(db: db, theme: theme, verrou: verrou));
}

class EscaleApp extends StatelessWidget {
  final AppDatabase db;
  final ThemeController theme;
  final VerrouController verrou;
  const EscaleApp({
    super.key,
    required this.db,
    required this.theme,
    required this.verrou,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: db),
        ChangeNotifierProvider<ThemeController>.value(value: theme),
        ChangeNotifierProvider<VerrouController>.value(value: verrou),
      ],
      child: Consumer<ThemeController>(
        builder: (context, theme, _) => MaterialApp(
          title: 'Escale',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: theme.mode,
          locale: const Locale('fr', 'FR'),
          supportedLocales: const [Locale('fr', 'FR')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const VerrouGate(child: AppShell()),
        ),
      ),
    );
  }
}
