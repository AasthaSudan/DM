import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
      _animationController.reset();
      _animationController.forward();
    });
  }

  Future<void> _handleAuth(AuthService authService) async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    HapticFeedback.lightImpact();

    bool success;
    if (_isLogin) {
      success = await authService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } else {
      success = await authService.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
      );
    }

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (authService.errorMessage != null) {
      _showSnackBar(authService.errorMessage!, isError: true);
    }
  }

  Future<void> _handleGoogleSignIn(AuthService authService) async {
    FocusScope.of(context).unfocus();
    HapticFeedback.lightImpact();

    bool success = await authService.signInWithGoogle();
    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (authService.errorMessage != null) {
      _showSnackBar(authService.errorMessage!, isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(fontSize: 15)),
            ),
          ],
        ),
        backgroundColor:
        isError ? Colors.red.shade400 : const Color(0xFF21C573),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _showForgotPasswordDialog(AuthService authService) async {
    final emailController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Enter your email address to receive a password reset link.'),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isNotEmpty) {
                Navigator.pop(context);
                final success = await authService.resetPassword(email);
                if (mounted) {
                  _showSnackBar(
                    success
                        ? 'Password reset email sent to $email'
                        : authService.errorMessage ??
                        'Failed to send reset email',
                    isError: !success,
                  );
                }
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF21C573), Color(0xFF1791B6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Card(
                  elevation: 8,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: size.width > 600 ? 500 : double.infinity),
                    padding: const EdgeInsets.all(32),
                    child: AbsorbPointer(
                      absorbing: authService.isLoading,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Logo
                            Container(
                              height: 80,
                              width: 80,
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color:
                                const Color(0xFF21C573).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.shield_outlined,
                                size: 40,
                                color: Color(0xFF21C573),
                              ),
                            ),

                            // Title
                            Text(
                              _isLogin ? 'Welcome Back!' : 'Create Account',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isLogin
                                  ? 'Sign in to continue to PrepareEd'
                                  : 'Join PrepareEd to stay prepared',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),

                            // Form Fields
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              child: Column(
                                children: [
                                  if (!_isLogin) ...[
                                    _buildNameField(),
                                    const SizedBox(height: 16),
                                  ],
                                  _buildEmailField(),
                                  const SizedBox(height: 16),
                                  _buildPasswordField(),
                                  if (!_isLogin) ...[
                                    const SizedBox(height: 16),
                                    _buildConfirmPasswordField(),
                                  ],
                                ],
                              ),
                            ),

                            // Forgot Password
                            if (_isLogin) ...[
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: authService.isLoading
                                      ? null
                                      : () => _showForgotPasswordDialog(
                                      authService),
                                  child: const Text('Forgot Password?'),
                                ),
                              ),
                            ],

                            const SizedBox(height: 24),

                            // Submit Button
                            authService.isLoading
                                ? const Center(
                                child: CircularProgressIndicator())
                                : ElevatedButton(
                              onPressed: () => _handleAuth(authService),
                              style: ElevatedButton.styleFrom(
                                minimumSize:
                                const Size(double.infinity, 54),
                                backgroundColor: const Color(0xFF21C573),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                _isLogin ? 'Login' : 'Sign Up',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Divider
                            Row(
                              children: [
                                Expanded(
                                    child: Divider(color: Colors.grey[300])),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    'OR',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Divider(color: Colors.grey[300])),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Google Button
                            _buildGoogleButton(authService),

                            const SizedBox(height: 24),

                            // Toggle Auth Mode
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _isLogin
                                      ? "Don't have an account? "
                                      : 'Already have an account? ',
                                ),
                                TextButton(
                                  onPressed: authService.isLoading
                                      ? null
                                      : _toggleAuthMode,
                                  child: Text(
                                    _isLogin ? 'Sign Up' : 'Login',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF21C573),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() => TextFormField(
    controller: _nameController,
    textInputAction: TextInputAction.next,
    autofillHints: const [AutofillHints.name],
    decoration: const InputDecoration(
      labelText: 'Full Name',
      prefixIcon: Icon(Icons.person_outline),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) return 'Please enter your name';
      if (value.length < 2) return 'Name must be at least 2 characters';
      return null;
    },
  );

  Widget _buildEmailField() => TextFormField(
    controller: _emailController,
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    autofillHints: const [AutofillHints.email],
    decoration: const InputDecoration(
      labelText: 'Email',
      prefixIcon: Icon(Icons.email_outlined),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) return 'Please enter your email';
      if (!value.contains('@') || !value.contains('.')) {
        return 'Enter a valid email';
      }
      return null;
    },
  );

  Widget _buildPasswordField() => TextFormField(
    controller: _passwordController,
    obscureText: _obscurePassword,
    textInputAction: _isLogin ? TextInputAction.done : TextInputAction.next,
    autofillHints: _isLogin
        ? const [AutofillHints.password]
        : const [AutofillHints.newPassword],
    decoration: InputDecoration(
      labelText: 'Password',
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(_obscurePassword
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined),
        onPressed: () =>
            setState(() => _obscurePassword = !_obscurePassword),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) return 'Enter your password';
      if (value.length < 6) {
        return 'Password must be at least 6 characters';
      }
      return null;
    },
    onFieldSubmitted:
    _isLogin ? (_) => _handleAuth(context.read<AuthService>()) : null,
  );

  Widget _buildConfirmPasswordField() => TextFormField(
    controller: _confirmPasswordController,
    obscureText: _obscureConfirmPassword,
    textInputAction: TextInputAction.done,
    decoration: InputDecoration(
      labelText: 'Confirm Password',
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(_obscureConfirmPassword
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined),
        onPressed: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password';
      }
      if (value != _passwordController.text) {
        return 'Passwords do not match';
      }
      return null;
    },
    onFieldSubmitted: (_) => _handleAuth(context.read<AuthService>()),
  );

  Widget _buildGoogleButton(AuthService authService) => OutlinedButton.icon(
    onPressed: authService.isLoading
        ? null
        : () => _handleGoogleSignIn(authService),
    icon: const Icon(Icons.g_mobiledata, size: 24, color: Colors.blue),
    label: Text(_isLogin ? 'Continue with Google' : 'Sign up with Google'),
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(double.infinity, 54),
      side: BorderSide(color: Colors.grey[300]!),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}