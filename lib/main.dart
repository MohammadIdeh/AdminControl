// lib/main.dart - Fixed with proper break statements
import 'package:admin_totp_panel/screens/m3lm_screen.dart';
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
        // Add this to make all page transitions fade
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: SlowFadePageTransitionsBuilder(),
            TargetPlatform.iOS: SlowFadePageTransitionsBuilder(),
            TargetPlatform.windows: SlowFadePageTransitionsBuilder(),
            TargetPlatform.macOS: SlowFadePageTransitionsBuilder(),
            TargetPlatform.linux: SlowFadePageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/':
            page = const SplashScreen();
            break;
          case '/login':
            page = const UnifiedLoginScreen();
            break;
          case '/dashboard':
            page = const DashboardScreen();
            break; // ← THIS WAS MISSING! Critical fix
          case '/m3lms':
            page = const M3lmScreen();
            break;
          case '/users':
            page = const UserScreen();
            break;
          default:
            page = const SplashScreen();
            break; // Added for consistency
        }

        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(
            milliseconds: 700,
          ), // Longer duration
          reverseTransitionDuration: const Duration(milliseconds: 700),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut, // Smoother curve
              ),
              child: child,
            );
          },
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// Custom slow fade transition builder
class SlowFadePageTransitionsBuilder extends PageTransitionsBuilder {
  const SlowFadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T extends Object?>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut, // Smoother, more noticeable curve
      ),
      child: child,
    );
  }
}
