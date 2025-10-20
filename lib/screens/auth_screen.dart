import 'package:flutter/material.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Form controllers and state
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _agree = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Simulated callbacks for social buttons and signup/signin
  void _onSignUp() {
    if (_agree &&
        _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.length >= 6) {
      // Handle sign-up logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signing up...')),
      );
    }
  }

  void _onSignInClick() {
    // Navigate to SignIn screen or show dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Sign In')),
    );
  }

  void _onGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign-In pressed')),
    );
  }

  void _onFacebook() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Facebook Sign-In pressed')),
    );
  }

  void _onApple() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple Sign-In pressed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use pastel green color for background
    Color pastelGreen = Color(0xFF388E3C); // You can modify this to any pastel green shade

    return Scaffold(
      body: Container(
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
          left: 24,
          right: 24,
          bottom: 20,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 8,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo Image
                    SizedBox(
                      height: 72,
                      width: 72,
                      child: Image.asset(
                        'assets/images/img.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Title
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Subtitle
                    const Text(
                      'Join our disaster preparedness community.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),

                    // Name Field
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: const Icon(Icons.person, color: Color(0xFF8E8E93)),
                        filled: true,
                        fillColor: const Color(0xFFF4F5F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Email Field
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email, color: Color(0xFF8E8E93)),
                        filled: true,
                        fillColor: const Color(0xFFF4F5F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'example@gmail.com',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Password Field
                    TextField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: const Color(0xFFF4F5F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword ? Icons.visibility : Icons.visibility_off,
                            color: const Color(0xFF8E8E93),
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Confirm Password Field
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: !_showConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        filled: true,
                        fillColor: const Color(0xFFF4F5F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                            color: const Color(0xFF8E8E93),
                          ),
                          onPressed: () {
                            setState(() {
                              _showConfirmPassword = !_showConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Terms & Conditions Checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: _agree,
                          activeColor: pastelGreen,
                          onChanged: (val) {
                            setState(() {
                              _agree = val ?? false;
                            });
                          },
                        ),
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: 'Agree with ',
                              style: const TextStyle(color: Colors.black, fontSize: 13),
                              children: [
                                TextSpan(
                                  text: 'Terms & Condition',
                                  style: TextStyle(
                                    color: pastelGreen,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                  // TODO: add gesture recognizer if you want link behavior
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _agree &&
                            _nameController.text.isNotEmpty &&
                            _emailController.text.isNotEmpty &&
                            _passwordController.text.length >= 6
                            ? _onSignUp
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: pastelGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Or Divider
                    _OrDivider(text: 'Or sign up with'),
                    const SizedBox(height: 14),

                    // Social Buttons Row
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
                        // You can add Apple or other buttons here similarly
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Bottom line
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
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
  }
}

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
          child: Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
        ),
        Expanded(child: Divider(thickness: 1, color: scrim)),
      ],
    );
  }
}

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
              ? Image.asset(assetName!, height: 24, width: 24, fit: BoxFit.contain)
              : Text(label ?? '', style: const TextStyle(fontSize: 22)),
        ),
      ),
    );
  }
}
