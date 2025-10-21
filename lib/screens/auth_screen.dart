import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _agree = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSignUp() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (!_agree) {
      _showMessage('Please agree to the Terms & Conditions');
      return;
    }
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showMessage('Please fill in all fields');
      return;
    }
    if (password != confirmPassword) {
      _showMessage('Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    bool success = await authService.signUpWithEmail(email, password, name);

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      _showMessage(authService.errorMessage ?? 'Sign-up failed');
    }
  }

  Future<void> _onGoogle() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    setState(() => _isLoading = true);
    bool success = await authService.signInWithGoogle();
    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      _showMessage(authService.errorMessage ?? 'Google Sign-In failed');
    }
  }

  void _onFacebook() {
    _showMessage('Facebook Sign-In not implemented yet');
  }

  void _onSignInClick() {
    _showMessage('Navigate to Sign In');
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    Color pastelGreen = const Color(0xFF388E3C);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isTablet = constraints.maxWidth > 600;
          bool isDesktop = constraints.maxWidth > 1000;
          double horizontalPadding = isDesktop
              ? screenWidth * 0.25
              : isTablet
              ? screenWidth * 0.15
              : 24;

          double cardWidth = isDesktop
              ? screenWidth * 0.45
              : isTablet
              ? screenWidth * 0.7
              : screenWidth * 0.9;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  pastelGreen.withOpacity(0.18),
                  Colors.white,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 0.45, 1],
              ),
            ),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: horizontalPadding,
              right: horizontalPadding,
              bottom: 20,
            ),
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: cardWidth),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 8,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 28 : 20,
                        vertical: isTablet ? 32 : 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: isTablet ? 90 : 72,
                            width: isTablet ? 90 : 72,
                            child: Image.asset(
                              'assets/images/img.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: isTablet ? 30 : 26,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF111111),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Join our disaster preparedness community.',
                            style: TextStyle(
                              fontSize: isTablet ? 15 : 13,
                              color: const Color(0xFF6B7280),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 18),

                          _buildTextField(
                            controller: _nameController,
                            label: 'Name',
                            icon: Icons.person,
                          ),
                          const SizedBox(height: 12),

                          _buildTextField(
                            controller: _emailController,
                            label: 'Email',
                            icon: Icons.email,
                            hint: 'example@gmail.com',
                          ),
                          const SizedBox(height: 12),

                          _buildPasswordField(
                            controller: _passwordController,
                            label: 'Password',
                            showText: _showPassword,
                            toggleVisibility: () {
                              setState(() => _showPassword = !_showPassword);
                            },
                          ),
                          const SizedBox(height: 12),

                          _buildPasswordField(
                            controller: _confirmPasswordController,
                            label: 'Confirm Password',
                            showText: _showConfirmPassword,
                            toggleVisibility: () {
                              setState(() => _showConfirmPassword =
                              !_showConfirmPassword);
                            },
                          ),
                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Checkbox(
                                value: _agree,
                                activeColor: pastelGreen,
                                onChanged: (val) =>
                                    setState(() => _agree = val ?? false),
                              ),
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Agree with ',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 13),
                                    children: [
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: TextStyle(
                                          color: pastelGreen,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _onSignUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: pastelGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                  color: Colors.white)
                                  : const Text(
                                'Sign Up',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                          const _OrDivider(text: 'Or sign up with'),
                          const SizedBox(height: 14),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SocialIconButton(
                                assetName: 'assets/images/img_4.png',
                                label: 'F',
                                onPressed: _onFacebook,
                              ),
                              const SizedBox(width: 14),
                              SocialIconButton(
                                assetName: 'assets/images/img_3.png',
                                label: 'G',
                                onPressed: _onGoogle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(
                                    fontSize: 13, color: Color(0xFF6B7280)),
                              ),
                              GestureDetector(
                                onTap: _onSignInClick,
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: pastelGreen,
                                    fontWeight: FontWeight.w600,
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
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF8E8E93)),
        filled: true,
        fillColor: const Color(0xFFF4F5F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool showText,
    required VoidCallback toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: !showText,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF4F5F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            showText ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFF8E8E93),
          ),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}

// ✅ Divider widget
class _OrDivider extends StatelessWidget {
  final String text;
  const _OrDivider({required this.text});

  @override
  Widget build(BuildContext context) {
    final scrim = const Color(0x14000000);
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: scrim)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),
        ),
        Expanded(child: Divider(thickness: 1, color: scrim)),
      ],
    );
  }
}

// ✅ Social button widget
class SocialIconButton extends StatelessWidget {
  final String? assetName;
  final String? label;
  final VoidCallback onPressed;

  const SocialIconButton({
    this.assetName,
    this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Container(
          height: 54,
          width: 54,
          alignment: Alignment.center,
          child: assetName != null
              ? Image.asset(
            assetName!,
            height: 24,
            width: 24,
            fit: BoxFit.contain,
          )
              : Text(label ?? '', style: const TextStyle(fontSize: 22)),
        ),
      ),
    );
  }
}
