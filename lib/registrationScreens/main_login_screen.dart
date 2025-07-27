import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import '../services/qr_code_service.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/generalWidgets/font.dart';

enum LoginState { main, admin, emailInput }

class UnifiedLoginScreen extends StatefulWidget {
  const UnifiedLoginScreen({super.key});

  @override
  State<UnifiedLoginScreen> createState() => _UnifiedLoginScreenState();
}

class _UnifiedLoginScreenState extends State<UnifiedLoginScreen>
    with TickerProviderStateMixin {
  LoginState _currentState = LoginState.main;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _changeState(LoginState newState) {
    if (_currentState != newState) {
      setState(() {
        _currentState = newState;
      });
      _slideController.forward(from: 0.0);
    }
  }

  void _goToMain() => _changeState(LoginState.main);
  void _goToAdmin() => _changeState(LoginState.admin);
  void _goToEmailInput() => _changeState(LoginState.emailInput);

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                    child: _buildCurrentWidget(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentWidget() {
    switch (_currentState) {
      case LoginState.main:
        return MainLoginWidget(
          key: const ValueKey('main'),
          onAdminLogin: _goToAdmin,
        );
      case LoginState.admin:
        return AdminLoginWidget(
          key: const ValueKey('admin'),
          onBack: _goToMain,
          onSuccess: _goToEmailInput,
        );
      case LoginState.emailInput:
        return EmailInputWidget(
          key: const ValueKey('email'),
          onBack: _goToMain,
          onSuccess: _goToMain,
        );
    }
  }
}

class MainLoginWidget extends StatefulWidget {
  final VoidCallback onAdminLogin;

  const MainLoginWidget({super.key, required this.onAdminLogin});

  @override
  State<MainLoginWidget> createState() => _MainLoginWidgetState();
}

class _MainLoginWidgetState extends State<MainLoginWidget> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _totpCode => _controllers.map((c) => c.text).join();

  void _onDigitChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    if (value.length > 1) {
      _controllers[index].text = value[value.length - 1];
    }

    setState(() {
      _errorMessage = null;
    });
  }

  Future<void> _handleLogin() async {
    if (_totpCode.length != 6) {
      setState(() {
        _errorMessage = "Please enter a complete 6-digit code";
      });
      return;
    }

    if (AuthService.isLockedOut('totp')) {
      setState(() {
        _errorMessage =
            "Too many failed attempts. Please try again in 15 minutes.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(seconds: 1));

    final isValid = await AuthService.validateTOTP(_totpCode);
    if (isValid) {
      if (mounted) {
        // Navigate to dashboard using named route
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard',
          (route) => false,
        );
      }
    } else {
      setState(() {
        _errorMessage =
            "Invalid TOTP code. "
            "${3 - AuthService.getFailedAttempts('totp')} attempts remaining.";
        _isLoading = false;
      });

      // Clear the input
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.security, size: 64, color: Color(0xFF1976D2)),
          const SizedBox(height: 24),
          Text(
            'TOTP Authentication',
            style: AppFonts.heading2.copyWith(color: const Color(0xFF1976D2)),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your 6-digit authentication code',
            style: AppFonts.bodyMedium.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              6,
              (index) => SizedBox(
                width: 48,
                height: 56,
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: AppFonts.custom(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF1976D2),
                        width: 2,
                      ),
                    ),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) => _onDigitChanged(value, index),
                ),
              ),
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: AppFonts.caption.copyWith(color: Colors.red[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Login',
                      style: AppFonts.button.copyWith(color: Colors.white),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: widget.onAdminLogin,
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: Text(
              'Log in as Admin',
              style: AppFonts.caption.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminLoginWidget extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSuccess;

  const AdminLoginWidget({
    super.key,
    required this.onBack,
    required this.onSuccess,
  });

  @override
  State<AdminLoginWidget> createState() => _AdminLoginWidgetState();
}

class _AdminLoginWidgetState extends State<AdminLoginWidget> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isObscured = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleAdminLogin() async {
    if (_controller.text.isEmpty) {
      setState(() {
        _errorMessage = "Please enter the master key";
      });
      return;
    }

    if (AuthService.isLockedOut('admin')) {
      setState(() {
        _errorMessage =
            "Too many failed attempts. Please try again in 15 minutes.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(seconds: 1));

    final isValid = await AuthService.validateMasterKey(_controller.text);
    if (isValid) {
      if (mounted) {
        widget.onSuccess();
      }
    } else {
      setState(() {
        _errorMessage =
            "Invalid master key. "
            "${3 - AuthService.getFailedAttempts('admin')} attempts remaining.";
        _isLoading = false;
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back),
                color: const Color(0xFF1976D2),
              ),
              const Expanded(
                child: Center(
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: 64,
                    color: Color(0xFF1976D2),
                  ),
                ),
              ),
              const SizedBox(width: 48), // Balance the back button
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Admin Access',
            style: AppFonts.heading2.copyWith(color: const Color(0xFF1976D2)),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the 25-character master key',
            style: AppFonts.bodyMedium.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _controller,
            obscureText: _isObscured,
            maxLength: 25,
            style: AppFonts.bodyMedium.copyWith(fontFamily: 'monospace'),
            decoration: InputDecoration(
              labelText: 'Master Key',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF1976D2),
                  width: 2,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () => setState(() => _isObscured = !_isObscured),
              ),
            ),
            onChanged: (value) => setState(() => _errorMessage = null),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: AppFonts.caption.copyWith(color: Colors.red[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleAdminLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Authenticate',
                      style: AppFonts.button.copyWith(color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmailInputWidget extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSuccess;

  const EmailInputWidget({
    super.key,
    required this.onBack,
    required this.onSuccess,
  });

  @override
  State<EmailInputWidget> createState() => _EmailInputWidgetState();
}

class _EmailInputWidgetState extends State<EmailInputWidget> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _successMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _sendQRCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _successMessage = null;
    });

    try {
      await QRCodeService.generateQRCode(_controller.text);

      setState(() {
        _isLoading = false;
        _successMessage = "QR code has been sent to ${_controller.text}";
      });

      // Auto navigate back after success
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        widget.onSuccess();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send QR code: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.home),
                  color: const Color(0xFF1976D2),
                ),
                const Expanded(
                  child: Center(
                    child: Icon(
                      Icons.qr_code,
                      size: 64,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Balance the back button
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Generate QR Code',
              style: AppFonts.heading2.copyWith(color: const Color(0xFF1976D2)),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter user email to send setup QR code',
              style: AppFonts.bodyMedium.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'user@example.com',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF1976D2),
                    width: 2,
                  ),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter an email address';
                }
                if (!_isValidEmail(value!)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            if (_successMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _successMessage!,
                        style: AppFonts.caption.copyWith(
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendQRCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        'Send Setup QR Code',
                        style: AppFonts.button.copyWith(color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'QR code will expire in 24 hours',
              style: AppFonts.caption.copyWith(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
