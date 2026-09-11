import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp est appelé immédiatement sans await bloquant
  runApp(
    const ProviderScope(
      child: AhiyoyoApp(),
    ),
  );
}

class AhiyoyoApp extends StatelessWidget {
  const AhiyoyoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ahiyoyo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Mode sombre exclusif
      routerConfig: appRouter,
    );
  }
}
