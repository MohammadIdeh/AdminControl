import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _masterKey = "ADMIN2025SECURE1234567890";
  static final Map<String, int> _failedAttempts = {};
  static final Map<String, DateTime> _lockoutTimes = {};
  static final List<String> _validTOTPCodes = ["123456", "789012", "456789"];
  
  // Keys for SharedPreferences
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _loginTimeKey = 'login_time';
  static const String _userTypeKey = 'user_type'; // 'totp' or 'admin'

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

  // Save login state to SharedPreferences
  static Future<void> _saveLoginState(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_loginTimeKey, DateTime.now().toIso8601String());
    await prefs.setString(_userTypeKey, userType);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    
    if (!isLoggedIn) return false;

    // Check if login is still valid (optional: add expiration logic)
    final loginTimeString = prefs.getString(_loginTimeKey);
    if (loginTimeString == null) return false;

    final loginTime = DateTime.parse(loginTimeString);
    final now = DateTime.now();
    
    // Optional: Auto-logout after 24 hours
    if (now.difference(loginTime).inHours >= 24) {
      await logout();
      return false;
    }

    return true;
  }

  // Get user type
  static Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTypeKey);
  }

  // Logout - clear all stored data
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_loginTimeKey);
    await prefs.remove(_userTypeKey);
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