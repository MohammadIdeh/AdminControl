import 'package:flutter/material.dart';
import '../../registrationScreens/main_login_screen.dart';
import '../../screens/dashboard_screen.dart';
import '../../services/auth_service.dart';
import 'font.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Add a small delay for better UX
    await Future.delayed(const Duration(seconds: 2));

    try {
      final isLoggedIn = await AuthService.isLoggedIn();

      if (mounted) {
        if (isLoggedIn) {
          // User is logged in, navigate to dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else {
          // User is not logged in, navigate to login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UnifiedLoginScreen()),
          );
        }
      }
    } catch (e) {
      // If there's an error checking auth status, go to login
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UnifiedLoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Icon/Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.security,
                  size: 64,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 32),

              // App Title
              Text(
                'M3lm Admin Panel',
                style: AppFonts.heading1.copyWith(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Secure Authentication Management',
                style: AppFonts.bodyMedium.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),

              const SizedBox(height: 48),

              // Loading Indicator
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.8),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Loading Text
              Text(
                'Checking authentication...',
                style: AppFonts.bodySmall.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
