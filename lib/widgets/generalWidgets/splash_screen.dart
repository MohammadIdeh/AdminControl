import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'font.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isCheckingAuth = true;
  String _statusMessage = 'Checking authentication...';

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Add a small delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      setState(() {
        _statusMessage = 'Verifying login status...';
      });

      final isLoggedIn = await AuthService.isLoggedIn();

      if (!mounted) return;

      // Add another small delay to prevent flicker
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        if (isLoggedIn) {
          // User is logged in, navigate to dashboard
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          // User is not logged in, navigate to login
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (e) {
      // If there's an error checking auth status, show error and go to login
      if (mounted) {
        setState(() {
          _statusMessage = 'Authentication check failed';
          _isCheckingAuth = false;
        });

        // Wait a moment then navigate to login
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
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

              // Loading Indicator or Error State
              if (_isCheckingAuth) ...[
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
              ] else ...[
                Icon(
                  Icons.error_outline,
                  size: 32,
                  color: Colors.white.withOpacity(0.8),
                ),
              ],

              const SizedBox(height: 16),

              // Status Text
              Text(
                _statusMessage,
                style: AppFonts.bodySmall.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),

              // Retry button if there's an error
              if (!_isCheckingAuth) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isCheckingAuth = true;
                      _statusMessage = 'Checking authentication...';
                    });
                    _checkAuthStatus();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Retry',
                    style: AppFonts.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
