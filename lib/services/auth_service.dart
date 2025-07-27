import 'package:flutter/foundation.dart';

class AuthService {
  static const String _masterKey = "ADMIN2025SECURE1234567890";
  static final Map<String, int> _failedAttempts = {};
  static final Map<String, DateTime> _lockoutTimes = {};
  static final List<String> _validTOTPCodes = ["123456", "789012", "456789"];

  // Temporary in-memory storage for web compatibility
  static bool _isLoggedIn = false;
  static DateTime? _loginTime;
  static String? _userType;

  static bool isLockedOut(String identifier) {
    final lockoutTime = _lockoutTimes[identifier];
    if (lockoutTime == null) return false;

    if (DateTime.now().difference(lockoutTime).inMinutes >= 15) {
      _lockoutTimes.remove(identifier);
      _failedAttempts.remove(identifier);
      return false;
    }
    return true;
  }

  static Future<bool> validateTOTP(String code) async {
    if (isLockedOut('totp')) return false;

    if (_validTOTPCodes.contains(code)) {
      _failedAttempts.remove('totp');
      // Save login state
      await _saveLoginState('totp');
      return true;
    }

    _failedAttempts['totp'] = (_failedAttempts['totp'] ?? 0) + 1;
    if (_failedAttempts['totp']! >= 3) {
      _lockoutTimes['totp'] = DateTime.now();
    }
    return false;
  }

  static Future<bool> validateMasterKey(String key) async {
    if (isLockedOut('admin')) return false;

    if (key == _masterKey) {
      _failedAttempts.remove('admin');
      // Save login state
      await _saveLoginState('admin');
      return true;
    }

    _failedAttempts['admin'] = (_failedAttempts['admin'] ?? 0) + 1;
    if (_failedAttempts['admin']! >= 3) {
      _lockoutTimes['admin'] = DateTime.now();
    }
    return false;
  }

  static int getFailedAttempts(String identifier) {
    return _failedAttempts[identifier] ?? 0;
  }

  // Save login state to memory (temporary solution)
  static Future<void> _saveLoginState(String userType) async {
    _isLoggedIn = true;
    _loginTime = DateTime.now();
    _userType = userType;

    if (kDebugMode) {
      print('✅ Login state saved: $userType at $_loginTime');
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    if (!_isLoggedIn || _loginTime == null) {
      return false;
    }

    final now = DateTime.now();

    // Optional: Auto-logout after 24 hours
    if (now.difference(_loginTime!).inHours >= 24) {
      await logout();
      return false;
    }

    if (kDebugMode) {
      print('✅ User is logged in as $_userType since $_loginTime');
    }

    return true;
  }

  // Get user type
  static Future<String?> getUserType() async {
    return _userType;
  }

  // Logout - clear all stored data
  static Future<void> logout() async {
    _isLoggedIn = false;
    _loginTime = null;
    _userType = null;

    if (kDebugMode) {
      print('🚪 User logged out - session cleared');
    }
  }

  // Check authentication status and get appropriate route
  static Future<String> getInitialRoute() async {
    final loggedIn = await isLoggedIn();
    if (loggedIn) {
      return '/dashboard';
    }
    return '/';
  }
}
