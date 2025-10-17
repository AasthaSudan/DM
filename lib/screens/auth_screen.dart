import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus(); // hide keyboard
    setState(() => _isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);
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

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (authService.errorMessage != null) {
      _showSnackBar(authService.errorMessage!, isError: true);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);
    bool success = await authService.signInWithGoogle();

    setState(() => _isLoading = false);

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
        content: Text(message, style: const TextStyle(fontSize: 15)),
        backgroundColor: isError ? Colors.red.shade400 : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      body: Center(
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.all(24),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isLogin ? 'Welcome Back!' : 'Create Account',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (!_isLogin) _buildNameField(),
                    _buildEmailField(),
                    _buildPasswordField(),
                    if (!_isLogin) _buildConfirmPasswordField(),

                    const SizedBox(height: 25),

                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _isLoading ? null : _handleAuth,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(_isLogin ? 'Login' : 'Sign Up'),
                    ),

                    const SizedBox(height: 16),

                    _buildGoogleButton(),

                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => setState(() => _isLogin = !_isLogin),
                      child: Text(
                        _isLogin
                            ? 'Don\'t have an account? Sign up'
                            : 'Already have an account? Login',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -------------------- Helper Widgets --------------------

  Widget _buildNameField() => TextFormField(
    controller: _nameController,
    decoration: const InputDecoration(labelText: 'Full Name'),
    validator: (value) =>
    value == null || value.isEmpty ? 'Please enter your name' : null,
  );

  Widget _buildEmailField() => TextFormField(
    controller: _emailController,
    keyboardType: TextInputType.emailAddress,
    decoration: const InputDecoration(labelText: 'Email'),
    validator: (value) {
      if (value == null || value.isEmpty) return 'Please enter your email';
      final emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
      if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
      return null;
    },
  );

  Widget _buildPasswordField() => TextFormField(
    controller: _passwordController,
    obscureText: _obscurePassword,
    decoration: InputDecoration(
      labelText: 'Password',
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: () =>
            setState(() => _obscurePassword = !_obscurePassword),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) return 'Enter your password';
      if (value.length < 6) return 'Password must be at least 6 characters';
      return null;
    },
  );

  Widget _buildConfirmPasswordField() => TextFormField(
    controller: _confirmPasswordController,
    obscureText: _obscureConfirmPassword,
    decoration: InputDecoration(
      labelText: 'Confirm Password',
      suffixIcon: IconButton(
        icon: Icon(
          _obscureConfirmPassword
              ? Icons.visibility
              : Icons.visibility_off,
        ),
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
  );

  Widget _buildGoogleButton() => OutlinedButton.icon(
    onPressed: _isLoading ? null : _handleGoogleSignIn,
    icon: Image.asset('assets/google_logo.png', height: 20),
    label: Text(_isLogin ? 'Login with Google' : 'Sign up with Google'),
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(double.infinity, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
