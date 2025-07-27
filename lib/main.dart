import 'package:admin_totp_panel/registrationScreens/main_login_screen.dart';
import 'package:flutter/material.dart';

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
        fontFamily: 'Inter',
      ),
      home: const MainLoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
