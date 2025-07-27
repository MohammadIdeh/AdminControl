class AuthService {
  static const String _masterKey = "ADMIN2025SECURE1234567890";
  static final Map<String, int> _failedAttempts = {};
  static final Map<String, DateTime> _lockoutTimes = {};
  static final List<String> _validTOTPCodes = ["123456", "789012", "456789"];

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

  static bool validateTOTP(String code) {
    if (isLockedOut('totp')) return false;

    if (_validTOTPCodes.contains(code)) {
      _failedAttempts.remove('totp');
      return true;
    }

    _failedAttempts['totp'] = (_failedAttempts['totp'] ?? 0) + 1;
    if (_failedAttempts['totp']! >= 3) {
      _lockoutTimes['totp'] = DateTime.now();
    }
    return false;
  }

  static bool validateMasterKey(String key) {
    if (isLockedOut('admin')) return false;

    if (key == _masterKey) {
      _failedAttempts.remove('admin');
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
}
