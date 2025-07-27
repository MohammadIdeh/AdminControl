import 'package:admin_totp_panel/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'registrationScreens/main_login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'widgets/generalWidgets/splash_screen.dart';

void main() {
  runApp(const TOTPAdminApp());
}

class TOTPAdminApp extends StatelessWidget {
  const TOTPAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M3lm Admin Panel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const UnifiedLoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/users': (context) => const UserScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
