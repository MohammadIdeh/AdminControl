class QRCodeService {
  static Future<String> generateQRCode(String email) async {
    // Simulate QR code generation
    await Future.delayed(const Duration(seconds: 2));

    final secret = _generateSecret();
    final qrData =
        "otpauth://totp/${Uri.encodeComponent(email)}?"
        "secret=$secret&issuer=${Uri.encodeComponent('TOTP Admin Panel')}";

    // Simulate sending email
    print("QR Code sent to $email: $qrData");

    return qrData;
  }

  static String _generateSecret() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    final random = DateTime.now().millisecondsSinceEpoch;
    var result = '';
    var seed = random;

    for (int i = 0; i < 32; i++) {
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      result += chars[seed % chars.length];
    }

    return result;
  }
}
