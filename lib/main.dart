import 'package:flutter/material.dart';
import 'registrationScreens/main_login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const TOTPAdminApp());
}

class TOTPAdminApp extends StatelessWidget {
  const TOTPAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TOTP Admin Panel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const UnifiedLoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
