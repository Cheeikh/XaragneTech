import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/login_page.dart';
import 'theme/app_theme.dart';
import 'models/app_state.dart';
import 'services/preferences_service.dart';
import 'services/notification_service.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser les services
  await PreferencesService().initialize();
  await NotificationService().initialize();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        Provider.value(value: AuthService()),
        Provider.value(value: NotificationService()),
        Provider.value(value: PreferencesService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final prefsService = context.read<PreferencesService>();
    final themeMode = prefsService.getThemeMode();

    return MaterialApp(
      title: 'FlexWallet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: Consumer<AppState>(
        builder: (context, appState, child) {
          return const LoginPage();
        },
      ),
    );
  }
}
