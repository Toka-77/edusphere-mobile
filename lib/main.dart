import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/login_screen.dart';
import 'theme_provider.dart';
import 'locale_provider.dart';

void main() {
  runApp(const EduSphereApp());
}

class EduSphereApp extends StatelessWidget {
  const EduSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return ValueListenableBuilder<String>(
          valueListenable: localeNotifier,
          builder: (context, lang, _) {
            return MaterialApp(
              title: 'EduSphere',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: mode,
              home: const LoginScreen(),
            );
          },
        );
      },
    );
  }
}
